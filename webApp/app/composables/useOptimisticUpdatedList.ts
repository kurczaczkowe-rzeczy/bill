import type { ChannelAction } from "~/utils/channelAction";
import { isNil } from "~/utils/isNil";

export function useOptimisticUpdatedList<ListItem extends { id: number }>(
  data: MaybeRefOrGetter<ListItem[] | undefined>,
) {
  const listToSync = ref<ListItem[]>([]);
  const disableAction = ref(new Map<number, ChannelAction[]>());

  function blockAction(id: number, action: ChannelAction) {
    if (disableAction.value.has(id)) {
      const actions = disableAction.value.get(id) as ChannelAction[];
      actions.push(action);
      return;
    }

    disableAction.value.set(id, [action]);
  }

  function releaseAction(id: number, action: ChannelAction) {
    if (!disableAction.value.has(id)) {
      return;
    }

    const actions = disableAction.value
      .get(id)
      ?.filter((_action) => _action !== action) as ChannelAction[];

    if (actions.length === 0) {
      disableAction.value.delete(id);
      return;
    }

    disableAction.value.set(id, actions);
  }

  function hasAction(action: ChannelAction): boolean {
    const channelActionsIterator = disableAction.value.values();

    let channelActions = channelActionsIterator.next().value;
    while (channelActions !== undefined) {
      if (channelActions.includes(action)) {
        return true;
      }
      channelActions = channelActionsIterator.next().value;
    }

    return false;
  }

  function isActionBlocked(id: number, action: ChannelAction): boolean {
    // ToDo: Workaround for insert action. If I don't block it, it will be inserted twice'
    if (!disableAction.value.has(id) && hasAction("insert")) {
      return true;
    }

    if (!disableAction.value.has(id)) {
      return false;
    }

    const actions = disableAction.value.get(id) as ChannelAction[];
    return actions.includes(action);
  }

  /* ToDo: Handle block/release action for promises
   * function handleManageAction(id: number, action: ChannelAction, promise: Promise<any>) {}
   * */

  function getList(id?: number | null): { list?: ListItem; index: number } {
    const index = getListIndex(id);

    return {
      list: listToSync.value?.[index] as ListItem,
      index,
    };
  }

  function getListIndex(id?: number | null): number {
    return listToSync.value?.findIndex((p) => p.id === id) ?? -1;
  }

  function upsertProduct(list?: ListItem | null, index?: number, overwrite?: boolean) {
    if (isNil(list)) {
      throw new Error("Invalid product");
    }

    const foundListIndex = getListIndex(list.id);
    const listIndex = !isNil(index) && index > -1 ? index : foundListIndex;

    if (listIndex === -1) {
      return listToSync.value.push(list as any) - 1;
    }

    const deletedCount = foundListIndex > -1 || overwrite ? 1 : 0;
    const item = deletedCount > 0 ? { ...listToSync.value[foundListIndex], ...list } : list;

    listToSync.value.splice(listIndex, deletedCount, item as any);

    return listIndex;
  }

  function deleteList(id?: number | null) {
    const listId = getListIndex(id);
    if (listId !== -1) {
      listToSync.value.splice(listId, 1);
    }
  }

  watch(data as any, (newData) => {
    const evaluatedData = toValue(newData);
    if (evaluatedData) {
      listToSync.value = evaluatedData;
    }
  });

  return {
    listToSync,
    getList,
    getListIndex,
    upsertProduct,
    deleteList,
    blockAction,
    releaseAction,
    isActionBlocked,
  };
}
