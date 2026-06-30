package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class CreateUserMealIngredient(
    val productId: String,
    val quantity: Int,
)