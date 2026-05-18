package pl.kurczaczkowe.bill.core.auth

import io.github.jan.supabase.auth.auth
import io.github.jan.supabase.auth.providers.builtin.Email
import io.github.jan.supabase.auth.status.SessionStatus
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import love.forte.plugin.suspendtrans.annotation.JsPromise
import pl.kurczaczkowe.bill.core.networking.RemoteClient
import kotlin.js.JsExport
import kotlin.js.JsName

@JsExport
class SupabaseAuthRepository(
    @JsName("remoteClient")
    private val remoteClient: RemoteClient
) : AuthRepository {
    @JsPromise
    @JsExport.Ignore
    override suspend fun currentUser(): AuthUser? {
        val user = remoteClient.client.auth.currentUserOrNull() ?: return null
        return AuthUser(id = user.id, email = user.email)
    }

    @JsPromise
    @JsExport.Ignore
    override suspend fun signIn(
        email: String,
        password: String
    ) {
        remoteClient.client.auth.signInWith(Email) {
            this.email = email
            this.password = password
        }
    }

    @JsPromise
    @JsExport.Ignore
    override suspend fun signUp(email: String, password: String) {
        remoteClient.client.auth.signUpWith(Email) {
            this.email = email
            this.password = password
        }
    }

    @JsPromise
    @JsExport.Ignore
    override suspend fun signOut() {
        remoteClient.client.auth.signOut()
    }

    override val authState: Flow<AuthUser?> = remoteClient.client.auth.sessionStatus.map { status ->
        when (status) {
            is SessionStatus.Authenticated -> currentUser()
            else -> null
        }
    }
}