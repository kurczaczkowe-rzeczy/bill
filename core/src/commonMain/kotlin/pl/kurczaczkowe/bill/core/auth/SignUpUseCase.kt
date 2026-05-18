package pl.kurczaczkowe.bill.core.auth

import love.forte.plugin.suspendtrans.annotation.JsPromise
import kotlin.js.JsExport

@JsExport
class SignUpUseCase(private val authRepository: AuthRepository) {
    @JsPromise
    @JsExport.Ignore
    suspend operator fun invoke(email: String, password: String) {
        require(email.isNotBlank()) { "Email is required" }
        require(password.length >= 6) { "Password is too short" }

        authRepository.signUp(email, password)
    }
}