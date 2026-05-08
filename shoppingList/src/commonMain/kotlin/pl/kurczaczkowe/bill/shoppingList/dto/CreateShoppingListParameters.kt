package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class CreateShoppingListParameters(
    @SerialName("p_name")
    val name: String,
    @SerialName("p_date")
    val date: String,
)