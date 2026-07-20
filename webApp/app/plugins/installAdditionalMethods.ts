export default defineNuxtPlugin(async () => {
  const lib = await import("@bill/packages/Bill-shoppingList");

  lib.installAdditionalMethods();
});
