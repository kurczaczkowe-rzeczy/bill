package pl.kurczaczkowe.bill.core.auth

import kotlin.js.JsExport

@JsExport
sealed interface AuthState

@JsExport
object AuthLoading: AuthState

@JsExport
object AuthUnauthenticated: AuthState

@JsExport
data class AuthAuthenticated(val user: AuthUser): AuthState

@JsExport
data class AuthError(val message: String): AuthState