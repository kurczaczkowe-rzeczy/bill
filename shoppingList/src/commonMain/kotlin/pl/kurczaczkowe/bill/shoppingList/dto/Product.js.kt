package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class Product(
    val id: Long,
    val createdAt: String,
    val name: String,
    val unit: UnitEnum,
)