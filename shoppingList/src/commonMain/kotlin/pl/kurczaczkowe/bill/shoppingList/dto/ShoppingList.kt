@file:JsExport
package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@Serializable
data class ShoppingList(
    val id: Long,
    @SerialName("created_at")
    val createdAt: String,
    val name: String,
    val date: String,
    @SerialName("product_amount")
    val productAmount: Int = 0
)