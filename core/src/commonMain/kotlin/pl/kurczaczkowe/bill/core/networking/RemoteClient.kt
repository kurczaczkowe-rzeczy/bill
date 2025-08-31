package pl.kurczaczkowe.bill.core.networking

import io.github.jan.supabase.SupabaseClient
import io.github.jan.supabase.postgrest.exception.PostgrestRestException
import io.github.jan.supabase.postgrest.postgrest
import io.github.jan.supabase.postgrest.result.PostgrestResult
import io.github.jan.supabase.realtime.PostgresAction
import io.github.jan.supabase.realtime.channel
import io.github.jan.supabase.realtime.postgresChangeFlow
import io.github.jan.supabase.realtime.realtime
import kotlinx.coroutines.CoroutineName
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.encodeToJsonElement
import love.forte.plugin.suspendtrans.annotation.JsPromise
import pl.kurczaczkowe.bill.core.util.NetworkError
import pl.kurczaczkowe.bill.core.util.Result
import kotlin.js.JsExport
import kotlin.js.JsName

@JsExport
class RemoteClient(
    @JsName("client")
    val client: SupabaseClient
) {
    private val clientScope = CoroutineScope(Dispatchers.Default + SupervisorJob())
    private val activeSubscriptions = mutableMapOf<String, Subscription>()

    @JsPromise
    @JsExport.Ignore
    suspend fun close() = client.close()

    fun get(url: String) {
        println("GET is not supported yet")
    }

    @JsPromise
    @JsExport.Ignore
    suspend inline fun <reified R> rpcCall(
        crossinline rpcCall: suspend () -> PostgrestResult
    ): Result<R, NetworkError> {
        return try {
            val response = rpcCall().decodeAsOrNull<Result.Success<R>>()
            if (response == null) {
                return Result.Success(Unit as R)
            }

            return response
        } catch (e: PostgrestRestException) {
            println(e)
            when(e.statusCode) {
                401 -> Result.Error(NetworkError.UNAUTHORIZED)
                404 -> Result.Error(NetworkError.NOT_FOUND)
                409 -> Result.Error(NetworkError.CONFLICT)
                408 -> Result.Error(NetworkError.REQUEST_TIMEOUT)
                413 -> Result.Error(NetworkError.PAYLOAD_TOO_LARGE)
                in 500..599 -> Result.Error(NetworkError.SERVER_ERROR)
                else -> Result.Error(NetworkError.UNKNOWN)
            }
        } catch (e: Exception) {
            println("RPC Exception: $e")
            e.printStackTrace()
            Result.Error(NetworkError.UNKNOWN)
        }
    }

    @JsExport.Ignore
    suspend inline fun <reified R> post(rpcFunction: String): Result<R, NetworkError> {
        return rpcCall<R> {
            client.postgrest.rpc(rpcFunction)
        }
    }

    @JsExport.Ignore
    suspend inline fun <reified P, reified R> post(
        rpcFunction: String,
        parameters: P
    ): Result<R, NetworkError> {
        return rpcCall<R> {
            val jsonParams = Json.encodeToJsonElement(parameters) as JsonObject
            client.postgrest.rpc(function = rpcFunction, parameters = jsonParams)
        }
    }

    fun subscribe(
        channelName: String,
        action: (PostgresAction) -> Unit,
        table: String
    ): Subscription {
        unsubscribe(channelName)

        val channel = client.realtime.channel(channelName)

        val changes = channel.postgresChangeFlow<PostgresAction>(schema = "public") {
            this.table = table
        }

        val job = clientScope.launch(CoroutineName("channel-$channelName")) {
            changes.collect { change ->
                try {
                    action(change)
                } catch (e: Exception) {
                    println("Error in channel $channelName: ${e.message}")
                }
            }
        }

        try {
            clientScope.launch {
                channel.subscribe()
            }

            val subscription = Subscription(
                job = job,
                channel = channel,
                channelName = channelName,
                scope = clientScope,
                onUnsubscribe = { unsubscribe(channelName) }
            )

            activeSubscriptions[channelName] = subscription

            return subscription
        } catch (e: Exception) {
            job.cancel()
            println("Failed to subscribe to channel $channelName: ${e.message}")
            throw e
        }
    }

    fun unsubscribe(channelName: String) {
        activeSubscriptions[channelName]?.let { subscription ->
            subscription.cleanup()
            activeSubscriptions.remove(channelName)
        }
    }

    fun unsubscribeAll() {
        activeSubscriptions.keys.toList().forEach { unsubscribe(it) }
    }

    @JsName("getActiveChannels")
    fun getActiveChannels(): Array<String> {
        return activeSubscriptions
            .filter { it.value.isActive() }
            .keys
            .toTypedArray()
    }

    fun dispose() {
        unsubscribeAll()
        clientScope.cancel()
    }
}
