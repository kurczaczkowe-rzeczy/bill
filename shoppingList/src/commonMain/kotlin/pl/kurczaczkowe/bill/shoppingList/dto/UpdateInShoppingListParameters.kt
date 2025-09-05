package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class UpdateInShoppingListParameters(
    val id: Long,
    val shopping_list_id: Long,
    val unit: UnitEnum?,
    val quantity: Float?,
    val name: String?,
    val category_id: String?,
)