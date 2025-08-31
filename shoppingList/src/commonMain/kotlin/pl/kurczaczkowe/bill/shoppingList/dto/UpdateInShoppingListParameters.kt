package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class UpdateInShoppingListParameters(
    val shopping_list_id: Long,
    val product_unit: UnitEnum,
    val product_quantity: Float,
    val product_name: String,
    val category_id: Long,
    val product_id: Long,
    val id: Long,
)