package pl.kurczaczkowe.bill.core.networking

import io.github.jan.supabase.SupabaseClient
import io.github.jan.supabase.postgrest.exception.PostgrestRestException
import io.github.jan.supabase.postgrest.postgrest
import io.github.jan.supabase.postgrest.result.PostgrestResult
import io.ktor.client.call.body
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.encodeToJsonElement
import pl.kurczaczkowe.bill.core.util.Result
import pl.kurczaczkowe.bill.core.util.NetworkError

class RemoteClient(
    val client: SupabaseClient
) {
    suspend fun close() = client.close()

    fun get(url: String) {
        println("GET is not supported yet")
    }

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
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }

    suspend inline fun <reified R> post(rpcFunction: String): Result<R, NetworkError> {
        return rpcCall<R> {
            client.postgrest.rpc(rpcFunction)
        }
    }

    suspend inline fun <reified P, reified R> post(
        rpcFunction: String,
        parameters: P
    ): Result<R, NetworkError> {
        return rpcCall<R> {
            val jsonParams = Json.encodeToJsonElement(parameters) as JsonObject
            client.postgrest.rpc(function = rpcFunction, parameters = jsonParams)
        }
    }
}