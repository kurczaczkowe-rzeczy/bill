import type { Category, CategoryClient } from "@bill/Bill-shoppingList";

import { useKtClientData } from "~/composables/useKtClientData";
import { useOptimisticUpdatedList } from "~/composables/useOptimisticUpdatedList";
import { useCategoryClient } from "~~/layers/category/composables/useCategoryClient";

type UseGetCategoriesOptions = CategoryOptions;

export function useGetCategories(options?: UseGetCategoriesOptions) {
  const { client, ...asyncDataOptions } = options ?? {};

  const categoryClient = client ?? useCategoryClient();

  return useKtClientData(`categories`, () => categoryClient.getCategoriesAsync(), asyncDataOptions);
}

type CategoryOptions = ClientOptions<Category[], CategoryClient>;

export function useCategory(options?: CategoryOptions) {
  const { client } = options ?? {};

  const loading = ref(false);
  const error = ref<Error | null>(null);

  const categoryClient = client ?? useCategoryClient();

  const {
    data,
    pending,
    error: fetchError,
  } = useGetCategories({ ...options, client: categoryClient });

  const { listToSync: categories } = useOptimisticUpdatedList(data);

  return {
    categories: readonly(categories),
    loading: readonly(computed(() => pending.value || loading.value)),
    error: readonly(computed(() => fetchError.value || error.value)),
  };
}
