export default defineNuxtPlugin(async () => {
  const supabaseRemoteClient = (await import("@bill/Bill-shoppingList/kotlin/Bill-core")).supabaseRemoteClient;

  const clientLoader = createKmpClientLoader(
    () => import("@bill/Bill-shoppingList"),
    (module) => {
      return new module.ShoppingListClient( supabaseRemoteClient.get() )
    },
  );

  const shoppingListClient = await clientLoader();

  return { provide: { shoppingListClient } };
});
