package pl.kurczaczkowe.bill.shoppingList

import love.forte.plugin.suspendtrans.annotation.JsPromise
import pl.kurczaczkowe.bill.core.networking.RemoteClient
import pl.kurczaczkowe.bill.core.networking.supabase
import pl.kurczaczkowe.bill.core.util.NetworkError
import pl.kurczaczkowe.bill.core.util.Result
import pl.kurczaczkowe.bill.shoppingList.dto.AddToShoppingListParameters
import pl.kurczaczkowe.bill.shoppingList.dto.CreateShoppingListParameters
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingList
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingListDesc
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingListDescParameters
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingListDetails
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingListParameters
import pl.kurczaczkowe.bill.shoppingList.dto.ToggleProductInCartParameters
import pl.kurczaczkowe.bill.shoppingList.dto.UnitEnum
import kotlin.js.JsExport
import kotlin.time.ExperimentalTime

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
                rpcFunction = "get_shopping_list", parameters = ShoppingListParameters(
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
            when (val res = client.post<List<ShoppingList>>(rpcFunction = "get_shopping_lists")) {
                is Result.Success -> {
                    val sorted = res.result.sortedByDescending { it.createdAt }
                    Result.Success(sorted)
                }

                is Result.Error -> res
            }

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
                parameters = ToggleProductInCartParameters(product_in_shopping_list_id = productInCartId)
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }

    @OptIn(ExperimentalTime::class)
    @JsPromise
    @JsExport.Ignore
    suspend fun createShoppingList(name: String): Result<Unit, NetworkError> {
        return try {
            val nowIso = kotlin.time.Clock.System.now().toString()

            client.post<CreateShoppingListParameters, Unit>(
                rpcFunction = "create_shopping_list",
                parameters = CreateShoppingListParameters( name = name, date = nowIso )
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }

    @OptIn(ExperimentalTime::class)
    @JsPromise
    @JsExport.Ignore
    suspend fun addToShoppingList(
        shoppingListId: Long,
        productUnit: UnitEnum,
        productQuantity: Double,
        productName: String,
        categoryId: Long,
    ): Result<Unit, NetworkError> {
        return try {
            client.post<AddToShoppingListParameters, Unit>(
                rpcFunction = "add_product_to_shopping_list",
                parameters = AddToShoppingListParameters(
                    shopping_list_id = shoppingListId,
                    product_unit = productUnit,
                    product_quantity = productQuantity,
                    product_name = productName,
                    category_id = categoryId,
                )
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }
}