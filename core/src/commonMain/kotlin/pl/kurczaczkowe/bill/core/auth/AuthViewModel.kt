package pl.kurczaczkowe.bill.core.auth

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import love.forte.plugin.suspendtrans.annotation.JsPromise
import kotlin.js.JsExport

@JsExport
class AuthViewModel(
    private val getCurrentUserUseCase: GetCurrentUserUseCase,
    private val observeAuthStateUseCase: ObserveAuthStateUseCase,
    private val signInUseCase: SignInUseCase,
    private val signUpUseCase: SignUpUseCase,
    private val signOutUseCase: SignOutUseCase
) {
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Default)
    private val _state = MutableStateFlow<AuthState>(AuthLoading)
    val state: StateFlow<AuthState> = _state.asStateFlow()

    init {
        startObserving()
    }

    @JsPromise
    @JsExport.Ignore
    suspend fun getCurrentUser(): AuthUser? {
        val currentUser = getCurrentUserUseCase()
        return currentUser
    }

    private fun startObserving() {
        scope.launch {
            observeAuthStateUseCase().collect { user ->
                _state.value = if (user != null) {
                    AuthAuthenticated(user = user)
                } else {
                    AuthUnauthenticated
                }
            }
        }
    }

    fun signIn(email: String, password: String) {
        scope.launch {
            _state.value = AuthLoading
            try {
                signInUseCase(email = email, password = password)
            } catch (e: Exception) {
                _state.value = AuthError(e.message ?: "Login failed.")
            }
        }
    }

    fun signUp(email: String, password: String) {
        scope.launch {
            _state.value = AuthLoading
            try {
                signUpUseCase(email = email, password = password)
            } catch (e: Exception) {
                _state.value = AuthError(e.message ?: "Registration failed.")
            }
        }
    }

    fun signOut() {
        scope.launch {
            signOutUseCase()
        }
    }

    fun getCurrentState(): AuthState = state.value

    fun onStateChange(callback: (AuthState) -> Unit) {
        scope.launch {
            state.collect { callback(it) }
        }
    }

    fun dispose() {
        scope.cancel()
    }
}