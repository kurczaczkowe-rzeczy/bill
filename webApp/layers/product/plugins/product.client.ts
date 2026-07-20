export default defineNuxtPlugin(async () => {
  const supabaseRemoteClient = (await import("@bill/packages/Bill-shoppingList/kotlin/Bill-core"))
    .supabaseRemoteClient;
  const clientLoader = createKmpClientLoader(
    () => import("@bill/packages/Bill-shoppingList"),
    (module) => new module.ProductClient(supabaseRemoteClient.get()),
  );

  const productClient = await clientLoader();

  return { provide: { productClient } };
});
