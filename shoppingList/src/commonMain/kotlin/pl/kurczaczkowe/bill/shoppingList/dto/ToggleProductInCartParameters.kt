package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class ToggleProductInCartParameters(
    val product_in_shopping_list_id: Long
)