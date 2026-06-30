package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class Ingredient(
    @SerialName("id")
    val id: String,
    @SerialName("name")
    val name: String,
    @SerialName("quantity")
    val quantity: Int,
    @SerialName("base_unit")
    val baseUnit: String,
    @SerialName("product_id")
    val productId: String,
    @SerialName("meal_ingredient_id")
    val mealIngredientId: String,
)