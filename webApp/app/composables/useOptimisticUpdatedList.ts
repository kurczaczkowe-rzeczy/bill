import type { ChannelAction } from "~/utils/channelAction";
import { isNil } from "~/utils/isNil";

interface Item {
  id: number;
}
type WithOnlyRequiredId<T> = T extends Item ? Partial<Omit<T, "id">> & Item : never;

export function useOptimisticUpdatedList<ListItem extends Item>(
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

  function getItem(id?: number | null): { item?: ListItem; index: number } {
    const index = getItemIndex(id);

    return {
      item: listToSync.value?.[index] as ListItem,
      index,
    };
  }

  function getItemIndex(id?: number | null): number {
    return listToSync.value?.findIndex((p) => p.id === id) ?? -1;
  }

  function upsertItem(
    item?: WithOnlyRequiredId<ListItem> | null,
    index?: number,
    overwrite?: boolean,
  ) {
    if (isNil(item)) {
      throw new Error("Invalid product");
    }

    const foundItemIndex = getItemIndex(item.id);
    const itemIndex = !isNil(index) && index > -1 ? index : foundItemIndex;

    if (itemIndex === -1) {
      // biome-ignore lint/suspicious/noExplicitAny: In this case it's ok'
      return listToSync.value.push(item as any) - 1;
    }

    const deletedCount = foundItemIndex > -1 || overwrite ? 1 : 0;
    const itemToInsert = deletedCount > 0 ? { ...listToSync.value[foundItemIndex], ...item } : item;

    // biome-ignore lint/suspicious/noExplicitAny: In this case it's ok'
    listToSync.value.splice(itemIndex, deletedCount, itemToInsert as any);

    return itemIndex;
  }

  function deleteItem(id?: number | null) {
    const itemId = getItemIndex(id);
    if (itemId !== -1) {
      listToSync.value.splice(itemId, 1);
    }
  }

  // biome-ignore lint/suspicious/noExplicitAny: In this case it's ok'
  watch(data as any, (newData) => {
    const evaluatedData = toValue(newData);
    if (evaluatedData) {
      listToSync.value = evaluatedData;
    }
  });

  return {
    listToSync,
    getItem,
    getItemIndex,
    upsertItem,
    deleteItem,
    blockAction,
    releaseAction,
    isActionBlocked,
  };
}
