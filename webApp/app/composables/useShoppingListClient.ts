import {
  type Category,
  type EntityId,
  getShoppingListChannelName,
  groupProductsByCategoryJs,
  type JsPostgresAction,
  type NetworkError,
  type Result,
  type ShoppingListDetails,
  type ShoppingListRow,
  type Subscription,
  UnitEnum,
} from "@bill/Bill-shoppingList";

import { type AsyncDataOptions, useNuxtData } from "#app";
import type { Channels } from "~/composables/types";
import { useOptimisticUpdatedList } from "~/composables/useOptimisticUpdatedList";
import { shoppingListClient } from "~/constants";
import { getChannelActionFrom } from "~/utils/channelAction";
import { isNil } from "~/utils/isNil";
import type { KtList } from "~/utils/ktListToArray";
import { ktToJs } from "~/utils/ktToJs";
import { readResponse } from "~/utils/readResponse";

type ListenerType = "shoppingListChanges";

type Options = AsyncDataOptions<ShoppingListDetails[]> & {
  useAutoListenFor?: MaybeRefOrGetter<ListenerType[]>;
};

export async function useShoppingList(listId?: MaybeRefOrGetter<unknown>, options?: Options) {
  const listIdRef = toRef(listId);
  const parsedListId = computed(() => routeListIdToNumber(toValue(listIdRef)));
  const channelName = computed(() => getShoppingListChannelName(toValue(parsedListId)));
  const loading = ref(false);
  const error = ref<Error | null>(null);
  const channel = ref<Channels>(new Map() as Channels);

  const { data: categories } = useNuxtData<Category[]>("categories");

  const {
    data,
    pending,
    error: fetchError,
    refresh,
  } = useAsyncData(
    `shoppingListDetails:${parsedListId.value}`,
    async () => {
      const response: Result<
        KtList<ShoppingListDetails>,
        NetworkError
      > = await shoppingListClient.getShoppingListAsync(parsedListId.value);

      return readResponse(response) as ShoppingListDetails[];
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
    listToSync: shoppingListDetails,
    getItem: __getProduct,
    upsertItem: __upsertProduct,
    deleteItem: __deleteProduct,
    getItemIndex: __getProductIndex,
    releaseAction,
    isActionBlocked,
    blockAction,
  } = useOptimisticUpdatedList(data);

  function __toggleInCart(id?: number | null, inCart?: boolean | null) {
    if (isNil(id)) {
      throw new Error("Invalid product id");
    }

    // @ts-expect-error ToDo: przez złe typy myśli, że jest readonly
    shoppingListDetails.value[id].inCart = inCart ?? shoppingListDetails.value[id]?.inCart;
  }

  async function listenForShoppingListChanges(): Promise<Subscription> {
    if (channel.value.has(channelName.value) && channel.value.get(channelName.value)) {
      shoppingListClient.unsubscribe(channel.value.get(channelName.value)!);
    }
    async function handleChanges(
      payload:
        | JsPostgresAction<ShoppingListRow, null>
        | JsPostgresAction<null, EntityId>
        | JsPostgresAction<ShoppingListRow, EntityId>,
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

        switch (
          channelAction // ToDo: Maybe this handler should be only source of truth?
        ) {
          case "insert": {
            const shoppingListProductPromise = shoppingListClient.getShoppingListProductAsync(
              jsPayload.record!.id,
            );
            if (!categories.value) {
              throw new Error("Categories not found");
            }

            const category =
              categories.value?.find((c) => c.id === jsPayload.record?.categoryId) ??
              categories.value?.[0];

            if (!category) {
              throw new Error("Category not found");
            }

            __upsertProduct({
              id: jsPayload.record!.id,
              createdAt: new Date().toISOString(),
              quantity: jsPayload.record!.quantity,
              unit: UnitEnum.GRAM.name,
              name: `Ładowanie...`, //ToDo: Add shrimmerlike thing
              inCart: jsPayload.record!.inCart,
              category,
            } as unknown as ShoppingListDetails);

            const response = await shoppingListProductPromise;
            const result = readResponse(response) as ShoppingListDetails;

            __upsertProduct(result);
            break;
          }
          case "update": {
            const shoppingListProductPromise = shoppingListClient.getShoppingListProductAsync(
              jsPayload.record!.id,
            );
            if (!categories.value) {
              throw new Error("Categories not found");
            }

            const category =
              categories.value?.find((c) => c.id === jsPayload.record?.categoryId) ??
              categories.value?.[0];

            if (!category) {
              throw new Error("Category not found");
            }

            __upsertProduct(jsPayload.record! as unknown as ShoppingListDetails);

            const response = await shoppingListProductPromise;
            const result = readResponse(response) as ShoppingListDetails;

            __upsertProduct(result);

            break;
          }
          case "delete":
            __deleteProduct(jsPayload.oldRecord!.id);

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
      shoppingListClient.listenForShoppingListChanges(parsedListId.value, handleChanges),
    );

    return channel.value.get(channelName.value) as Subscription;
  }

  async function toggleInCart(id: number) {
    if (!shoppingListDetails.value) {
      throw new Error("Shopping list not found");
    }

    const oldProduct = __getProduct(id);
    if (!oldProduct.item) {
      throw new Error("Product not found");
    }

    loading.value = true;
    blockAction(id, "update");

    __upsertProduct(
      {
        id: oldProduct.item.id,
        inCart: oldProduct.item.inCart,
      },
      oldProduct.index,
      true,
    );

    shoppingListClient
      .toggleProductInCartAsync(id)
      .then((response) => {
        const result = readResponse(response) as ShoppingListDetails;
        __upsertProduct(result, oldProduct.index, true);
      })
      .catch((error) => {
        __upsertProduct(oldProduct.item, oldProduct.index, true);
        console.error(error);
      })
      .finally(() => {
        loading.value = false;
        releaseAction(id, "update");
      });
  }

  async function addToShoppingList(
    params: AddToShoppingListParameters & { listId: unknown },
  ): Promise<Result<void, NetworkError>> {
    if (params.name.trim() === "") {
      throw new Error("Nazwa powinna być wypełniona");
    }

    return shoppingListClient.addToShoppingListAsync(
      routeListIdToNumber(params.listId),
      UnitEnum.valueOf(params.unit.name),
      params.quantity,
      params.name,
      params.categoryId,
    );
  }

  onMounted(() => {
    if (toValue(options?.useAutoListenFor)?.includes("shoppingListChanges")) {
      listenForShoppingListChanges();
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
    shoppingListDetails: readonly(shoppingListDetails),
    loading: readonly(computed(() => pending.value || loading.value)),
    error: readonly(computed(() => fetchError.value || error.value)),

    // Actions
    refresh,
    listenForShoppingListChanges,
    toggleInCart,
    addToShoppingList,

    // Utils
    categoriesWithProducts: computed(() =>
      shoppingListDetails.value && categories.value
        ? ktToJs(groupProductsByCategoryJs(shoppingListDetails.value, categories.value))
        : [],
    ),
  };
}

function routeListIdToNumber(id: any): number {
  const preparedId = Array.isArray(id) ? id[0] : id;

  if (preparedId === undefined || preparedId === null) {
    throw new Error(
      `Invalid list ID. It should be a string or number. Actual value: ${preparedId}`,
    );
  }

  const parsedId = parseInt(preparedId, 10);
  if (Number.isNaN(parsedId)) {
    throw new Error(`Invalid list ID. Is not a number. Actual value: ${preparedId}`);
  }
  return parsedId;
}

export interface AddToShoppingListParameters {
  name: string;
  quantity: number;
  unit: UnitEnum;
  categoryId: number;
}
