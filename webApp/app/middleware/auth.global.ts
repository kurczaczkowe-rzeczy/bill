export default defineNuxtRouteMiddleware(async (to, _from) => {
  const AuthAuthenticated = (await import("@bill/Bill-shoppingList/kotlin/Bill-core"))
    .AuthAuthenticated;

  const { $authViewModel } = useNuxtApp();

  const state = $authViewModel?.getCurrentState?.();

  const publicRoutes = ["/auth/login", "/auth/register", "/auth/reset-password", "/auth/callback"];
  const isPublic = publicRoutes.includes(to.path);
  const isAuthenticated = state instanceof AuthAuthenticated;

  if (!isAuthenticated && !isPublic) {
    // return navigateTo('/auth/login')
  }

  if (isAuthenticated && isPublic) {
    // return navigateTo('/')
  }
});
