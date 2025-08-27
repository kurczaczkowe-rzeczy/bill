import {
  type Category,
  getShoppingListChannelName,
  groupProductsByCategoryJs,
  type JsPostgresAction,
  type NetworkError,
  type Result,
  type ShoppingListDetails,
  type Subscription,
  UnitEnum,
} from "@bill/Bill-shoppingList";

import { type AsyncDataOptions, useNuxtData } from "#app";
import { shoppingListClient } from "~/constants";
import { isNil } from "~/utils/isNil";
import type { KtList } from "~/utils/ktListToArray";
import { ktToJs } from "~/utils/ktToJs";
import { readResponse } from "~/utils/readResponse";

type Channels = Map<string, Subscription>;
type ListenerType = "shoppingListChanges";

type Options = AsyncDataOptions<ShoppingListDetails[]> & {
  useAutoListenFor?: MaybeRefOrGetter<ListenerType[]>;
};

export async function useShoppingList(listId?: MaybeRefOrGetter<unknown>, options?: Options) {
  const listIdRef = toRef(listId);
  const parsedListId = computed(() => routeListIdToNumber(toValue(listIdRef)));
  const channelName = computed(() => getShoppingListChannelName(toValue(parsedListId)));
  const shoppingListDetails = ref<ShoppingListDetails[]>([]);
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
    `shoppingListDetails:${parsedListId}`,
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

  watch(data, (newData) => {
    if (newData) {
      shoppingListDetails.value = newData;
    }
  });

  // shoppingListDetails ref manipulations
  function __getProduct(id?: number | null): ShoppingListDetails | undefined {
    return shoppingListDetails.value?.find((p) => p.id === id);
  }

  function __getProductIndex(id?: number | null): number {
    return shoppingListDetails.value?.findIndex((p) => p.id === id) ?? -1;
  }

  function __toggleInCart(id?: number | null, inCart?: boolean | null) {
    if (isNil(id)) {
      throw new Error("Invalid product id");
    }

    // @ts-expect-error ToDo: przez złe typy myśli, że jest readonly
    shoppingListDetails.value[id].inCart = inCart ?? shoppingListDetails.value[id]?.inCart;
  }

  function __upsertProduct(product?: ShoppingListDetails | null) {
    if (isNil(product)) {
      throw new Error("Invalid product");
    }

    const productId = __getProductIndex(product.id);
    if (productId === -1) {
      shoppingListDetails.value.push(product);
      return;
    }

    shoppingListDetails.value[productId] = product;
  }

  function __deleteProduct(id?: number | null) {
    shoppingListDetails.value.filter((product) => product.id !== id);
  }

  function listenForShoppingListChanges(): Subscription {
    if (channel.value.has(channelName.value)) {
      channel.value.get(channelName.value)?.unsubscribe();
    }
    async function handleChanges(payload: JsPostgresAction) {
      const jsPayload = ktToJs(payload);

      const productId = __getProductIndex(jsPayload.record?.id);

      if (productId === -1 || isNil(productId)) {
        if (isNil(jsPayload.oldRecord) && !isNil(jsPayload.record)) {
          const shoppingListProductPromise = shoppingListClient.getShoppingListProductAsync(
            jsPayload.record.id,
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
            id: jsPayload.record.id,
            createdAt: new Date().toISOString(),
            quantity: jsPayload.record.quantity,
            unit: UnitEnum.GRAM.name,
            name: `Produkt`, //ToDo: Add shrimmerlike thing
            inCart: jsPayload.record.inCart,
            category,
          } as unknown as ShoppingListDetails);

          try {
            const response = await shoppingListProductPromise;
            const result = readResponse(response) as ShoppingListDetails;
            const newProductId = __getProductIndex(result.id);

            if (newProductId === -1 || newProductId === undefined) {
              throw new Error("Product not found");
            }

            shoppingListDetails.value[newProductId] = result;
          } catch (error) {
            console.error(error);
          }
        }

        return;
      }

      __toggleInCart(productId, jsPayload.record?.inCart);
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

    const productId = __getProductIndex(id);
    if (productId === -1 || isNil(shoppingListDetails.value[productId])) {
      throw new Error("Product not found");
    }

    const prev = { ...shoppingListDetails.value[productId] };
    __toggleInCart(productId, shoppingListDetails.value[productId].inCart);

    shoppingListClient
      .toggleProductInCartAsync(id)
      .then(readResponse)
      .catch((error) => {
        __upsertProduct(prev);
        console.error(error);
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
    channel.value.forEach((subscription) => {
      subscription.unsubscribe();
    });
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
