package pl.kurczaczkowe.bill.core.auth

import kotlinx.coroutines.flow.Flow
import love.forte.plugin.suspendtrans.annotation.JsPromise
import kotlin.js.JsExport

@JsExport
interface AuthRepository {
    @JsPromise
    @JsExport.Ignore
    suspend fun currentUser(): AuthUser?

    @JsPromise
    @JsExport.Ignore
    suspend fun signIn(
        email: String,
        password: String
    )

    @JsPromise
    @JsExport.Ignore
    suspend fun signUp(
        email: String,
        password: String
    )

    @JsPromise
    @JsExport.Ignore
    suspend fun signOut()

    val authState: Flow<AuthUser?>
}