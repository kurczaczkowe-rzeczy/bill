export default defineNuxtPlugin(async (nuxtApp) => {
  const { $supabaseClient } = nuxtApp;

  const clientLoader = createKmpClientLoader(
    () => import("@bill/Bill-shoppingList"),
    (module) => {
      return new module.ShoppingListClient($supabaseClient);
    },
  );

  const shoppingListClient = await clientLoader();

  return { provide: { shoppingListClient } };
});
