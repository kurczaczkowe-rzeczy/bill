export default defineNuxtPlugin(async () => {
  const supabaseRemoteClient = (await import("@bill/Bill-shoppingList/kotlin/Bill-core"))
    .supabaseRemoteClient;
  const clientLoader = createKmpClientLoader(
    () => import("@bill/Bill-shoppingList"),
    (module) => new module.MenuClient(supabaseRemoteClient.get()),
  );

  const menuClient = await clientLoader();

  return { provide: { menuClient } };
});
