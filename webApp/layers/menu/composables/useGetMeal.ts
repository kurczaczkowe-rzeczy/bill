import type { MenuClient, UserMealWithIngredients } from "@bill/Bill-shoppingList";

import { useKtClientData } from "~/composables/useKtClientData";
import { getStringParam } from '~/utils/getStringParam'
// import { useOptimisticUpdatedList } from "~/composables/useOptimisticUpdatedList";

import { useMenuClient } from "./useMenuClient";

type MenuOptions = ClientOptions<UserMealWithIngredients, MenuClient>;

type UseGetMealOptions = MenuOptions;

export function useGetMeal(listId?: MaybeRefOrGetter<unknown>, options?: UseGetMealOptions) {
  const { client, ...asyncDataOptions } = options ?? {};

  const listIdRef = toRef(listId);
  const parsedListId = computed(() => getStringParam(toValue(listIdRef)));
  const menuClient = client ?? useMenuClient();

  return useKtClientData(`meals:${parsedListId.value}`, () => menuClient.getMealAsync(toValue(parsedListId)), asyncDataOptions);
}
