export default defineNuxtPlugin(async () => {
  const clientLoader = createKmpClientLoader(
    () => import("@bill/Bill-shoppingList"),
    (module) => new module.ShoppingListClient(),
  );

  const shoppingListClient = await clientLoader();

  return { provide: { shoppingListClient } };
});
