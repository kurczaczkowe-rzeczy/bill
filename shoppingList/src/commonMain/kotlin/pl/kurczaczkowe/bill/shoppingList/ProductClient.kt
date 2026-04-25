package pl.kurczaczkowe.bill.shoppingList

import love.forte.plugin.suspendtrans.annotation.JsPromise
import pl.kurczaczkowe.bill.core.networking.RemoteClient
import pl.kurczaczkowe.bill.core.util.NetworkError
import pl.kurczaczkowe.bill.core.util.Result
import pl.kurczaczkowe.bill.shoppingList.dto.DisplayUnit
import pl.kurczaczkowe.bill.shoppingList.dto.Product
import pl.kurczaczkowe.bill.shoppingList.dto.ProductSuggestionParameters
import kotlin.js.JsExport

@JsExport
class ProductClient(private val client: RemoteClient) {
    @JsPromise
    @JsExport.Ignore
    suspend fun getProductSuggestion(
        name: String,
    ): Result<List<Product>, NetworkError> {
        return try {
            client.post<ProductSuggestionParameters, List<Product>>(
                rpcFunction = "get_product_suggestion",
                parameters = ProductSuggestionParameters(
                    name = name,
                )
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }
    @JsPromise
    @JsExport.Ignore
    suspend fun getDisplayUnits(): Result<List<DisplayUnit>, NetworkError> {
        return try {
            client.post<List<DisplayUnit>>(
                rpcFunction = "get_display_units",
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }
}