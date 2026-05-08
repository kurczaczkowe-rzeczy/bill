package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class Product(
    val id: String,
    @SerialName("created_at")
    val createdAt: String,
    val name: String,
    @SerialName("base_unit")
    val baseUnit: String,
)