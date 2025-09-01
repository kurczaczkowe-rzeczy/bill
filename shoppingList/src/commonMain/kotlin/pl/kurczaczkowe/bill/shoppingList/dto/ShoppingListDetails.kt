package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class ShoppingListDetails(
    val id: Long,
    @SerialName("created_at")
    val createdAt: String,
    val quantity: Int,
    val unit: UnitEnum,
    val name: String,
    @SerialName("in_cart")
    val inCart: Boolean,
    val category: Category,
)