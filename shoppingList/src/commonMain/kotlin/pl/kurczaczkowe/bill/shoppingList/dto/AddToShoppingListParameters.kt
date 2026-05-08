package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class AddToShoppingListParameters(
    @SerialName("p_shopping_list_id")
    val shoppingListId: String,
    @SerialName("p_product_base_unit")
    val productBaseUnit: String,
    @SerialName("p_product_quantity")
    val productQuantity: Float,
    @SerialName("p_product_name")
    val productName: String,
    @SerialName("p_category_id")
    val categoryId: String,
)