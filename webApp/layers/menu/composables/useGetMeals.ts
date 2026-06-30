import type { MenuClient, UserMeal } from "@bill/Bill-shoppingList";

import { useKtClientData } from "~/composables/useKtClientData";
// import { useOptimisticUpdatedList } from "~/composables/useOptimisticUpdatedList";

import { useMenuClient } from "./useMenuClient";

type MenuOptions = ClientOptions<UserMeal[], MenuClient>;

type UseGetMealsOptions = MenuOptions;

export function useGetMeals(options?: UseGetMealsOptions) {
  const { client, ...asyncDataOptions } = options ?? {};

  const menuClient = client ?? useMenuClient();

  return useKtClientData(`meals`, () => menuClient.getMealsAsync(), asyncDataOptions);
}
