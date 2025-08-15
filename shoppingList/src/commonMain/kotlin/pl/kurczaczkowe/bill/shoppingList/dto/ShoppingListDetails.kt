package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class ShoppingListDetails(
    val id: Long,
    val createdAt: String,
    val quantity: Int,
    val unit: UnitEnum,
    val name: String,
    val inCart: Boolean,
    val category: Category,
)