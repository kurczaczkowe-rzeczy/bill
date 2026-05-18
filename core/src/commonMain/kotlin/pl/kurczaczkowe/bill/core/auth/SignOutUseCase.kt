package pl.kurczaczkowe.bill.core.auth

import love.forte.plugin.suspendtrans.annotation.JsPromise
import kotlin.js.JsExport

@JsExport
class SignOutUseCase(private val authRepository: AuthRepository) {
    @JsPromise
    @JsExport.Ignore
    suspend operator fun invoke() = authRepository.signOut()
}