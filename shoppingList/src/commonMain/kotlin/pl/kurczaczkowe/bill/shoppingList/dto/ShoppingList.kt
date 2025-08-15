package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class ShoppingList(
    val id: Long,
    val createdAt: String,
    val name: String,
    val date: String,
    val productAmount: Int
)