package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class CategoryWithProducts(
    val category: Category,
    val products: List<ShoppingListDetails>
)