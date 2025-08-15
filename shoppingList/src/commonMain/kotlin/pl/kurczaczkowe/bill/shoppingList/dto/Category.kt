package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class Category(
    val id: Long,
    val createdAt: String,
    val name: String,
    val color: String
)