package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class CreateMealWithIngredients(
    val name: String,
    val type: String,
    val recipeDesc: String,
    val recipeLink: String,
    val servings: Int,
    val servingsMultiplier: Double,
    val ingredients: Array<CreateUserMealIngredient>
)