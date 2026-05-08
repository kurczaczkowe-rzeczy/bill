package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class UpdateInShoppingListParameters(
    @SerialName("p_id")
    val id: String,
    @SerialName("p_shopping_list_id")
    val shoppingListId: String,
    @SerialName("p_base_unit")
    val baseUnit: String?,
    @SerialName("p_quantity")
    val quantity: Float?,
    @SerialName("p_name")
    val name: String?,
    @SerialName("p_category_id")
    val categoryId: String?,
)