export default defineNuxtPlugin(async () => {
  if (process.env.NODE_ENV !== "development") {
    return;
  }

  const route = useRoute();

  if (route.query.debug === "true" || localStorage.getItem("debug") === "true") {
    const eruda = await import("eruda");
    eruda.default.init();

    localStorage.setItem("debug", "true");
  }
});
