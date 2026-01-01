export function useShoppingListClient() {
  const { $shoppingListClient } = useNuxtApp();
  return $shoppingListClient;
}