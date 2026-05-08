package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class ShoppingListProductParameters(
    @SerialName("p_product_in_shopping_list_id")
    val productInShoppingListId: String
)
