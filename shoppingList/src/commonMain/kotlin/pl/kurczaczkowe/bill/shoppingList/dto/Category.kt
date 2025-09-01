package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class Category(
    val id: Long,
    @SerialName("created_at")
    val createdAt: String,
    val name: String,
    val color: String
)