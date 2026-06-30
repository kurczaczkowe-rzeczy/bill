package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class CreateMealWithIngredientsParameters(
    @SerialName("p_name")
    val name: String,
    @SerialName("p_type")
    val type: String,
    @SerialName("p_receipe_desc")
    val recipeDesc: String,
    @SerialName("p_receipe_link")
    val recipeLink: String,
    @SerialName("p_servings")
    val servings: Int,
    @SerialName("p_servings_multiplier")
    val servingsMultiplier: Double,
    @SerialName("p_ingredients")
    val ingredients: List<CreateUserMealIngredientParameter>
)