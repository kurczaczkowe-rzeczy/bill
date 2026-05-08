package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@JsExport
@Serializable
data class ShoppingListRow(
    val id: String,
    val quantity: Int? = null,
    @SerialName("product_id")
    val productId: String? = null,
    @SerialName("in_cart")
    val inCart: Boolean? = null,
    @SerialName("category_id")
    val categoryId: String? = null,
    @SerialName("shopping_list_id")
    val shoppingListId: String? = null,
)