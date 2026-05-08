package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class DeleteShoppingListParameters(
    @SerialName("p_shopping_list_id")
    val shoppingListId: String,
)