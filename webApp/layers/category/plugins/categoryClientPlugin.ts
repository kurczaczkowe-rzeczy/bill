export default defineNuxtPlugin(async () => {
  const clientLoader = createKmpClientLoader(
    () => import("@bill/Bill-shoppingList"),
    (module) => new module.CategoryClient(),
  );

  const categoryClient = await clientLoader();

  return { provide: { categoryClient } };
});
