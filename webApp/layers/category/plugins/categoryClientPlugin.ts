export default defineNuxtPlugin(async () => {
  const supabaseRemoteClient = (await import("@bill/Bill-shoppingList/kotlin/Bill-core")).supabaseRemoteClient;
  const clientLoader = createKmpClientLoader(
    () => import("@bill/Bill-shoppingList"),
    (module) => new module.CategoryClient(supabaseRemoteClient.get()),
  );

  const categoryClient = await clientLoader();

  return { provide: { categoryClient } };
});
