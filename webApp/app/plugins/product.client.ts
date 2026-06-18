export default defineNuxtPlugin(async (nuxtApp) => {
  const { $supabaseClient } = nuxtApp;

  const clientLoader = createKmpClientLoader(
    () => import("@bill/Bill-shoppingList"),
    (module) => new module.ProductClient($supabaseClient),
  );

  const productClient = await clientLoader();

  return { provide: { productClient } };
});
