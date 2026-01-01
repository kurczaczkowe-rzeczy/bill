import type { ShoppingListClient } from "@bill/Bill-shoppingList";

export default defineNuxtPlugin(async () => {
  const clientLoader = createKmpClientLoader<ShoppingListClient>(
    () => import("@bill/Bill-shoppingList"),
    (module) => new module.ShoppingListClient(),
  );

  const shoppingListClient = await clientLoader();

  return { provide: { shoppingListClient } };
});
