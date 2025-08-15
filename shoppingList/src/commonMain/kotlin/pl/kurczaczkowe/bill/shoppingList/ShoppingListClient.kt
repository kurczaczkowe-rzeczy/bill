package pl.kurczaczkowe.bill.shoppingList

import love.forte.plugin.suspendtrans.annotation.JsPromise
import pl.kurczaczkowe.bill.core.networking.RemoteClient
import pl.kurczaczkowe.bill.core.networking.supabase
import pl.kurczaczkowe.bill.core.util.NetworkError
import pl.kurczaczkowe.bill.core.util.Result
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingList
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingListDesc
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingListDescParameters
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingListDetails
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingListParameters
import pl.kurczaczkowe.bill.shoppingList.dto.ToggleProductInCartParameters
import kotlin.js.JsExport

@JsExport
class ShoppingListClient {
    private val client = RemoteClient(client = supabase)

    @JsPromise
    @JsExport.Ignore
    suspend fun getShoppingListDesc(
        shoppingListId: Long,
    ): Result<ShoppingListDesc, NetworkError> {
        return try {
            client.post<ShoppingListDescParameters, ShoppingListDesc>(
                rpcFunction = "get_shopping_list_desc",
                parameters = ShoppingListDescParameters(id = shoppingListId)
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }

    @JsPromise
    @JsExport.Ignore
    suspend fun getShoppingList(
        shoppingListId: Long,
    ): Result<List<ShoppingListDetails>, NetworkError> {
        return try {
            client.post<ShoppingListParameters, List<ShoppingListDetails>>(
                rpcFunction = "get_shopping_list",
                parameters = ShoppingListParameters(
                    shopping_list_id = shoppingListId
                )
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }

    @JsPromise
    @JsExport.Ignore
    suspend fun getShoppingLists(): Result<List<ShoppingList>, NetworkError> {
        return try {
            client.post<List<ShoppingList>>(
                rpcFunction = "get_shopping_lists",
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }

    @JsPromise
    @JsExport.Ignore
    suspend fun toggleProductInCart(productInCartId: Long): Result<Unit, NetworkError> {
        return try {
            client.post<ToggleProductInCartParameters, Unit>(
                rpcFunction = "toggle_product_in_cart",
                parameters = ToggleProductInCartParameters(productInCartId)
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }
}