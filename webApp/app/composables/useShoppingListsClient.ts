import {
  type EntityId,
  getShoppingListsChannelName,
  type JsPostgresAction,
  type NetworkError,
  type Result,
  type ShoppingList,
  type Subscription,
} from "@bill/Bill-shoppingList";

import type { AsyncDataOptions } from "#app";
import type { Channels } from "~/composables/types";
import { useOptimisticUpdatedList } from "~/composables/useOptimisticUpdatedList";
import { shoppingListClient } from "~/constants";
import { getChannelActionFrom } from "~/utils/channelAction";
import { ktToJs } from "~/utils/ktToJs";
import { readResponse } from "~/utils/readResponse";

type ListenerType = "shoppingListsChanges";

type Options = AsyncDataOptions<ShoppingList[]> & {
  useAutoListenFor?: MaybeRefOrGetter<ListenerType[]>;
};

export async function useShoppingLists(options?: Options) {
  const channelName = computed(() => getShoppingListsChannelName());
  const loading = ref(false);
  const error = ref<Error | null>(null);
  const channel = ref<Channels>(new Map() as Channels);

  const {
    data,
    pending,
    error: fetchError,
    refresh,
  } = useAsyncData(
    "shoppingLists",
    async () => {
      const response = await shoppingListClient.getShoppingListsAsync();

      return readResponse(response) as ShoppingList[];
    },
    {
      getCachedData(key) {
        const nuxtApp = useNuxtApp();
        const data = nuxtApp.payload.data[key] || nuxtApp.static.data[key];
        if (!data) return;

        const expirationDate = new Date(data.fetchedAt);
        expirationDate.setTime(expirationDate.getTime() + 5 * 60 * 1000);
        if (new Date() < expirationDate) {
          return data;
        }
      },
      server: false,
      ...options,
    },
  );

  const {
    listToSync: shoppingLists,
    getList: __getList,
    upsertProduct: __upsertProduct,
    deleteList: __deleteList,
    releaseAction,
    isActionBlocked,
    blockAction,
  } = useOptimisticUpdatedList(data);

  async function listenForShoppingListsChanges(): Promise<Subscription> {
    if (channel.value.has(channelName.value) && channel.value.get(channelName.value)) {
      shoppingListClient.unsubscribe(channel.value.get(channelName.value)!);
    }

    async function handleChanges(
      payload:
        | JsPostgresAction<ShoppingList, null>
        | JsPostgresAction<ShoppingList, EntityId>
        | JsPostgresAction<null, EntityId>,
    ) {
      try {
        const jsPayload = ktToJs(payload);
        const channelAction = getChannelActionFrom(jsPayload);
        const isBlocked = isActionBlocked(
          jsPayload.record?.id ?? jsPayload.oldRecord?.id,
          channelAction,
        );

        if (isBlocked) {
          return;
        }

        switch (channelAction) {
          case "insert": {
            __upsertProduct(
              {
                id: jsPayload.record!.id,
                createdAt: new Date().toISOString(),
                name: jsPayload.record!.name,
                date: jsPayload.record!.date,
                productAmount: jsPayload.record!.productAmount,
              } as ShoppingList,
              0,
            );

            break;
          }
          case "update":
            __upsertProduct({
              id: jsPayload.record!.id,
              createdAt: new Date().toISOString(),
              name: jsPayload.record!.name,
              date: jsPayload.record!.date,
            } as ShoppingList);

            break;
          case "delete":
            __deleteList(jsPayload.oldRecord!.id);

            break;
          default:
            throw new Error("Invalid payload");
        }
      } catch (error) {
        console.error(error);
      }
    }

    channel.value.set(
      channelName.value,
      shoppingListClient.listenForShoppingListsChanges(handleChanges),
    );

    return channel.value.get(channelName.value) as Subscription;
  }

  async function addShoppingList(
    params: AddShoppingListParameters,
  ): Promise<Result<ShoppingList, NetworkError>> {
    if (params.name.trim() === "") {
      throw new Error("Nazwa powinna być wypełniona");
    }

    loading.value = true;
    const now = new Date();
    const preparedId = now.valueOf() * 2;
    blockAction(preparedId, "insert");

    __upsertProduct(
      {
        id: preparedId,
        createdAt: now.toISOString(),
        name: params.name,
        date: new Intl.DateTimeFormat("pl-PL").format(now),
        productAmount: 0,
      } as ShoppingList,
      0,
    );

    return shoppingListClient
      .createShoppingListAsync(params.name)
      .then((response) => {
        const parsedRes = readResponse(response);

        __upsertProduct(parsedRes, 0, true);
        return response;
      })
      .catch((err) => {
        console.error(err);

        return err;
      })
      .finally(() => {
        loading.value = false;
        releaseAction(preparedId, "insert");
      });
  }

  async function updateShoppingList(
    params: UpdateShoppingListParameters,
  ): Promise<Result<void, NetworkError>> {
    if (params.name?.trim() === "") {
      throw new Error("Nazwa powinna być wypełniona");
    }
    const listToUpdate = __getList(params.id);

    __upsertProduct({ ...params } as ShoppingList, listToUpdate.index);

    return shoppingListClient
      .updateShoppingListAsync(params.id, params.name, params.date)
      .then((response) => {
        const parsedRes = readResponse(response);
        __upsertProduct(parsedRes, listToUpdate.index);
        return response;
      })
      .catch((err) => {
        console.error(err);
        __upsertProduct(listToUpdate.list, listToUpdate.index);
        return err;
      })
      .finally(() => {
        loading.value = false;
      });
  }

  async function deleteShoppingList(
    params: DeleteShoppingListParameters,
  ): Promise<Result<EntityId, NetworkError>> {
    const listToDelete = __getList(params.id);

    loading.value = true;
    __deleteList(params.id);

    return shoppingListClient
      .deleteShoppingListAsync(params.id)
      .catch((err) => {
        console.error(err);
        __upsertProduct(listToDelete.list, listToDelete.index);
        return err;
      })
      .finally(() => {
        loading.value = false;
      });
  }

  onMounted(() => {
    if (toValue(options?.useAutoListenFor)?.includes("shoppingListsChanges")) {
      listenForShoppingListsChanges();
    }
  });

  onUnmounted(() => {
    try {
      channel.value.forEach((subscription) => {
        shoppingListClient.unsubscribe(subscription);
      });
    } catch (e) {
      console.error(e);
    }
  });

  return {
    // State
    shoppingLists: readonly(shoppingLists),
    loading: readonly(computed(() => pending.value || loading.value)),
    error: readonly(computed(() => fetchError.value || error.value)),

    // Actions
    refresh,
    listenForShoppingListsChanges,
    addShoppingList,
    updateShoppingList,
    deleteShoppingList,
    // Utils
  };
}

export interface AddShoppingListParameters {
  name: string;
  date?: string;
}
export interface UpdateShoppingListParameters {
  name?: string;
  id: number;
  date?: string;
}
export interface DeleteShoppingListParameters {
  id: number;
}
