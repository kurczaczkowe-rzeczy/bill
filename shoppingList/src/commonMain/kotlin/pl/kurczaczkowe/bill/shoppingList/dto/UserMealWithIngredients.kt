package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class UserMealWithIngredients(
    @SerialName("id")
    val id: String,
    @SerialName("name")
    val name: String,
    @SerialName("type")
    val type: String,
    @SerialName("servings")
    val servings: Int,
    @SerialName("created_at")
    val createdAt: String,
    @SerialName("updated_at")
    val updatedAt: String,
    @SerialName("receipe_desc")
    val recipeDesc: String,
    @SerialName("receipe_link")
    val recipeLink: String,
    @SerialName("original_meal_id")
    val originalMealId: String,
    @SerialName("servings_multiplier")
    val servingsMultiplier: Double,
    val ingredients: List<Ingredient>,
)