package pl.kurczaczkowe.bill.shoppingList

import io.github.jan.supabase.realtime.PostgresAction
import love.forte.plugin.suspendtrans.annotation.JsPromise
import pl.kurczaczkowe.bill.core.networking.RemoteClient
import pl.kurczaczkowe.bill.core.networking.Subscription
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
import pl.kurczaczkowe.bill.shoppingList.dto.UpdateInShoppingListParameters
import pl.kurczaczkowe.bill.shoppingList.dto.UpdateShoppingListParameters
import kotlin.js.JsExport
import kotlin.js.JsName
import kotlin.time.ExperimentalTime

@JsExport
class ShoppingListClient(private val client: RemoteClient) {
    // GENERAL

    fun unsubscribe(subscription: Subscription) = subscription.unsubscribe()

    fun unsubscribeAll() = client.unsubscribeAll()

    @JsPromise
    @JsExport.Ignore
    suspend fun close() = client.close()

    // SHOPPING LIST
    @JsPromise
    @JsExport.Ignore
    suspend fun getShoppingListDesc(
        shoppingListId: String,
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
        shoppingListId: String,
    ): Result<List<ShoppingListDetails>, NetworkError> {
        return try {
            client.post<ShoppingListParameters, List<ShoppingListDetails>>(
                rpcFunction = "get_shopping_list", parameters = ShoppingListParameters(
                    shoppingListId = shoppingListId
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
        productInShoppingListId: String,
    ): Result<ShoppingListDetails, NetworkError> {
        return try {
            client.post<ShoppingListProductParameters, ShoppingListDetails>(
                rpcFunction = "get_product_from_shopping_list", parameters = ShoppingListProductParameters(
                    productInShoppingListId = productInShoppingListId
                )
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }

    @JsPromise
    @JsExport.Ignore
    suspend fun toggleProductInCart(productInCartId: String): Result<ShoppingListDetails, NetworkError> {
        return try {
            client.post<ToggleProductInCartParameters, ShoppingListDetails>(
                rpcFunction = "toggle_product_in_cart",
                parameters = ToggleProductInCartParameters(productInShoppingListId = productInCartId)
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }

    @JsPromise
    @JsExport.Ignore
    suspend fun addToShoppingList(
        shoppingListId: String,
        productBaseUnit: String,
        productQuantity: Float,
        productName: String,
        categoryId: String,
    ): Result<ShoppingListDetails, NetworkError> {
        return try {
            client.post<AddToShoppingListParameters, ShoppingListDetails>(
                rpcFunction = "add_product_to_shopping_list",
                parameters = AddToShoppingListParameters(
                    shoppingListId = shoppingListId,
                    productBaseUnit = productBaseUnit,
                    productQuantity = productQuantity,
                    productName = productName,
                    categoryId = categoryId,
                )
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }

    @JsName("listenForShoppingListChangesPlain")
    fun listenForShoppingListChanges(
        listId: String,
        action: (PostgresAction) -> Unit,
    ): Subscription = client.subscribe(
        channelName = getShoppingListChannelName(listId = listId),
        action = action,
        table = "product_in_shopping_list"
    )

    @JsPromise
    @JsExport.Ignore
    suspend fun updateInShoppingList(
        id: String,
        shoppingListId: String,
        productBaseUnit: String?,
        productQuantity: Float?,
        productName: String?,
        categoryId: String?,
    ): Result<ShoppingListDetails, NetworkError> {
        return try {
            client.post<UpdateInShoppingListParameters, ShoppingListDetails>(
                rpcFunction = "edit_product_in_shopping_list",
                parameters = UpdateInShoppingListParameters(
                    shoppingListId = shoppingListId,
                    baseUnit = productBaseUnit,
                    quantity = productQuantity,
                    name = productName,
                    categoryId = categoryId,
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
        productInShoppingListId: String,
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
        id: String,
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
    suspend fun deleteShoppingList(id: String): Result<EntityId, NetworkError> {
        return try {
            client.post<DeleteShoppingListParameters, EntityId>(
                rpcFunction = "remove_shopping_list",
                parameters = DeleteShoppingListParameters( shoppingListId = id )
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
fun getShoppingListChannelName(listId: String) = "shopping-list-$listId"

@JsExport
fun getShoppingListsChannelName() = "shopping-lists"
