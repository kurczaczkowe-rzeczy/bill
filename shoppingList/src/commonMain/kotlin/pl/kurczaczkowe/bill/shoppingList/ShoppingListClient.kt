package pl.kurczaczkowe.bill.shoppingList

import io.github.jan.supabase.realtime.PostgresAction
import love.forte.plugin.suspendtrans.annotation.JsPromise
import pl.kurczaczkowe.bill.core.networking.RemoteClient
import pl.kurczaczkowe.bill.core.networking.Subscription
import pl.kurczaczkowe.bill.core.networking.supabaseRemoteClient
import pl.kurczaczkowe.bill.core.util.NetworkError
import pl.kurczaczkowe.bill.core.util.Result
import pl.kurczaczkowe.bill.shoppingList.dto.AddToShoppingListParameters
import pl.kurczaczkowe.bill.shoppingList.dto.CreateShoppingListParameters
import pl.kurczaczkowe.bill.shoppingList.dto.DeleteFromShoppingListParameters
import pl.kurczaczkowe.bill.shoppingList.dto.DeleteShoppingListParameters
import pl.kurczaczkowe.bill.shoppingList.dto.EntityId
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingList
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingListDesc
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingListDescParameters
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingListDetails
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingListParameters
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingListProductParameters
import pl.kurczaczkowe.bill.shoppingList.dto.ToggleProductInCartParameters
import pl.kurczaczkowe.bill.shoppingList.dto.UnitEnum
import pl.kurczaczkowe.bill.shoppingList.dto.UpdateInShoppingListParameters
import pl.kurczaczkowe.bill.shoppingList.dto.UpdateShoppingListParameters
import kotlin.js.JsExport
import kotlin.js.JsName
import kotlin.time.ExperimentalTime

@JsExport
class ShoppingListClient(private val client: RemoteClient = supabaseRemoteClient) {
    // GENERAL

    fun unsubscribe(subscription: Subscription) = subscription.unsubscribe()

    fun unsubscribeAll() = client.unsubscribeAll()

    // SHOPPING LIST
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
    suspend fun getShoppingListProduct(
        productInShoppingListId: Long,
    ): Result<ShoppingListDetails, NetworkError> {
        return try {
            client.post<ShoppingListProductParameters, ShoppingListDetails>(
                rpcFunction = "get_product_from_shopping_list", parameters = ShoppingListProductParameters(
                    product_in_shopping_list_id = productInShoppingListId
                )
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }

    @JsPromise
    @JsExport.Ignore
    suspend fun toggleProductInCart(productInCartId: Long): Result<ShoppingListDetails, NetworkError> {
        return try {
            client.post<ToggleProductInCartParameters, ShoppingListDetails>(
                rpcFunction = "toggle_product_in_cart",
                parameters = ToggleProductInCartParameters(product_in_shopping_list_id = productInCartId)
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }

    @JsPromise
    @JsExport.Ignore
    suspend fun addToShoppingList(
        shoppingListId: Long,
        productUnit: UnitEnum,
        productQuantity: Float,
        productName: String,
        categoryId: Long,
    ): Result<ShoppingListDetails, NetworkError> {
        return try {
            client.post<AddToShoppingListParameters, ShoppingListDetails>(
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

    @JsName("listenForShoppingListChangesPlain")
    fun listenForShoppingListChanges(
        listId: Long,
        action: (PostgresAction) -> Unit,
    ): Subscription = client.subscribe(
        channelName = getShoppingListChannelName(listId = listId),
        action = action,
        table = "product_in_shopping_list"
    )

    @JsPromise
    @JsExport.Ignore
    suspend fun updateInShoppingList(
        id: Long,
        shoppingListId: Long,
        productUnit: UnitEnum?,
        productQuantity: Float?,
        productName: String?,
        categoryId: Long?,
    ): Result<ShoppingListDetails, NetworkError> {
        return try {
            client.post<UpdateInShoppingListParameters, ShoppingListDetails>(
                rpcFunction = "edit_product_in_shopping_list",
                parameters = UpdateInShoppingListParameters(
                    shopping_list_id = shoppingListId,
                    unit = productUnit,
                    quantity = productQuantity,
                    name = productName,
                    category_id = categoryId?.toString(),
                    id = id,
                )
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }

    @JsPromise
    @JsExport.Ignore
    suspend fun deleteFromShoppingList(
        productInShoppingListId: Long,
    ): Result<EntityId, NetworkError> {
        return try {
            client.post<DeleteFromShoppingListParameters, EntityId>(
                rpcFunction = "remove_product_from_shopping_list",
                parameters = DeleteFromShoppingListParameters(
                    id = productInShoppingListId,
                )
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }

    // LIST OF SHOPPING LISTS
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

    @OptIn(ExperimentalTime::class)
    @JsPromise
    @JsExport.Ignore
    suspend fun createShoppingList(name: String): Result<ShoppingList, NetworkError> {
        return try {
            val nowIso = kotlin.time.Clock.System.now().toString()

            client.post<CreateShoppingListParameters, ShoppingList>(
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
    suspend fun updateShoppingList(
        id: Long,
        name: String?,
        date: String?,
    ): Result<ShoppingList, NetworkError> {
        return try {
            client.post<UpdateShoppingListParameters, ShoppingList>(
                rpcFunction = "edit_shopping_list",
                parameters = UpdateShoppingListParameters( id = id, name = name, date = date )
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }

    @JsPromise
    @JsExport.Ignore
    suspend fun deleteShoppingList(id: Long): Result<EntityId, NetworkError> {
        return try {
            client.post<DeleteShoppingListParameters, EntityId>(
                rpcFunction = "remove_shopping_list",
                parameters = DeleteShoppingListParameters( shopping_list_id = id )
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }

    @JsName("listenForShoppingListsChangesPlain")
    fun listenForShoppingListsChanges(
        action: (PostgresAction) -> Unit,
    ): Subscription = client.subscribe(
        channelName = getShoppingListsChannelName(),
        action = action,
        table = "shopping_list"
    )

}

@JsExport
fun getShoppingListChannelName(listId: Long) = "shopping-list-$listId"

@JsExport
fun getShoppingListsChannelName() = "shopping-lists"
