package pl.kurczaczkowe.bill.shoppingList

import love.forte.plugin.suspendtrans.annotation.JsPromise
import pl.kurczaczkowe.bill.core.networking.RemoteClient
import pl.kurczaczkowe.bill.core.networking.supabaseRemoteClient
import pl.kurczaczkowe.bill.core.util.NetworkError
import pl.kurczaczkowe.bill.core.util.Result
import pl.kurczaczkowe.bill.shoppingList.dto.Category
import kotlin.js.JsExport

@JsExport
class CategoryClient(private val client: RemoteClient = supabaseRemoteClient) {
    @JsPromise
    @JsExport.Ignore
    suspend fun getCategories(): Result<List<Category>, NetworkError> {
        return try {
            client.post<List<Category>>(
                rpcFunction = "get_categories",
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }
}