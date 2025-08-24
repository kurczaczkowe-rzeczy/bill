package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@JsExport
@Serializable
data class ShoppingListDetail(
    @SerialName("_id") val id: Long,
    @SerialName("_quantity") val quantity: Int? = null,
    @SerialName("_product_id") val productId: Long? = null,
    @SerialName("_in_cart") val inCart: Boolean? = null,
    @SerialName("_category_id") val categoryId: Long? = null,
    @SerialName("_shopping_list_id") val shoppingListId: Long? = null,
)