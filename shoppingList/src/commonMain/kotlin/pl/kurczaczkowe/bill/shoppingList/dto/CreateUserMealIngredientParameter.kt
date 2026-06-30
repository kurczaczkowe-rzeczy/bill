package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class CreateUserMealIngredientParameter(
    @SerialName("product_id")
    val productId: String,
    val quantity: Int,
)