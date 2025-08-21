package pl.kurczaczkowe.bill.shoppingList.utils

import pl.kurczaczkowe.bill.shoppingList.dto.Category
import pl.kurczaczkowe.bill.shoppingList.dto.CategoryWithProducts
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingListDetails
import kotlin.js.JsExport

@JsExport
fun groupProductsByCategory(
    products: List<ShoppingListDetails>,
    categories: List<Category>
): List<CategoryWithProducts> {
    val groupedProducts = products.groupBy { it.category.id }

    return categories.mapNotNull { category ->
        val categoryProducts = groupedProducts[category.id]?.sortedBy { it.inCart } ?: emptyList()

        if (categoryProducts.isEmpty()) {
            null
        } else {
            CategoryWithProducts(
                category = category,
                products = categoryProducts
            )
        }
    }
}