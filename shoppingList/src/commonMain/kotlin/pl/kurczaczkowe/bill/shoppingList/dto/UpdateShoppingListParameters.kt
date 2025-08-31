package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class UpdateShoppingListParameters(
    val id: Long,
    val name: String?,
    val date: String?,
)