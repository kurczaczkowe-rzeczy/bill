import type { AuthState } from "@bill/Bill-shoppingList/kotlin/Bill-core";

export function useAuth() {
  const { $authViewModel } = useNuxtApp()

  const viewModel = useState( 'auth', () => $authViewModel )
  const authState = useState<AuthState>('auth-state', () => viewModel.value?.getCurrentState?.())

  async function signIn( logInParameters: LogInParameters ) {
    try {
      viewModel.value?.signIn( logInParameters.email, logInParameters.password )
    } catch ( error ) {
      console.error( error )
    }
  }

  async function signOut() {
    try {
      viewModel.value?.signOut()
    } catch ( error ) {
      console.error( error )
    }
  }

  async function signUp( registerParameters: RegisterParameters ) {
    try {
      viewModel.value?.signUp( registerParameters.email, registerParameters.password )
    } catch ( error ) {
      console.error( error )
    }
  }

  async function resetPassword( _email: ResetPasswordEmail ) {
    try {
      // viewModel.value?.resetPassword( email )
    } catch ( error ) {
      console.error( error )
    }
  }

  async function getUser() {
    return viewModel.value?.getCurrentUserAsync()
  }

  if (import.meta.client) {
    viewModel.value?.onStateChange((newState: AuthState) => {
      authState.value = newState
    })
  }

  return {
    signIn,
    signUp,
    signOut,
    resetPassword,
    state: authState,
    getUser,
    viewModel,
  }
}

export interface LogInParameters {
  email: string;
  password: string;
}

export interface RegisterParameters {
  email: string;
  password: string;
}

type ResetPasswordEmail = string