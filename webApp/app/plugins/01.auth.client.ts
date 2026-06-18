export default defineNuxtPlugin(async (nuxtApp) => {
  const { $supabaseClient: supabaseClient } = nuxtApp;
  const {
    AuthViewModel,
    GetCurrentUserUseCase,
    ObserveAuthStateUseCase,
    SignInUseCase,
    SignOutUseCase,
    SignUpUseCase,
    SupabaseAuthRepository,
  } = await import("@bill/Bill-shoppingList/kotlin/Bill-core");

  const authRepo = new SupabaseAuthRepository(supabaseClient);

  const authViewModel = new AuthViewModel(
    new GetCurrentUserUseCase(authRepo),
    new ObserveAuthStateUseCase(authRepo),
    new SignInUseCase(authRepo),
    new SignUpUseCase(authRepo),
    new SignOutUseCase(authRepo),
  );

  return { provide: { authViewModel } };
});
