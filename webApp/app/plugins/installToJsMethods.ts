export default defineNuxtPlugin(async () => {
  const lib = await import("@bill/Bill-shoppingList");

  lib.installToJsMethods();
});
