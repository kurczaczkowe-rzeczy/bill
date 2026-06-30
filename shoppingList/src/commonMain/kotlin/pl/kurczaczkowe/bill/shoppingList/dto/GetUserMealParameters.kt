package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class GetUserMealParameters(
    @SerialName("p_user_meal_id")
    val userMealId: String,
)