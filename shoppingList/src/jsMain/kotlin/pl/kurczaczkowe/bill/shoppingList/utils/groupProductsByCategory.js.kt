package pl.kurczaczkowe.bill.shoppingList.utils

import pl.kurczaczkowe.bill.shoppingList.dto.Category
import pl.kurczaczkowe.bill.shoppingList.dto.CategoryWithProducts
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingListDetails
import pl.kurczaczkowe.bill.shoppingList.dto.UnitEnum

@JsExport
fun groupProductsByCategoryJs(
    products: Array<dynamic>,
    categories: Array<dynamic>
): List<CategoryWithProducts> {
    val productsList = products.map { p ->
        ShoppingListDetails(
            id = (p.id as Number).toLong(),
            name = p.name as String,
            category = Category(
                id = (p.category.id as Number).toLong(),
                createdAt = (p.category.createdAt as String),
                name = (p.category.name as String),
                color = (p.category.color as String),
            ),
            quantity = (p.quantity as Number).toInt(),
            unit = UnitEnum.valueOf(p.unit as String),
            inCart = p.inCart as Boolean,
            createdAt = p.createdAt as String,
        )
    }

    val categoriesList = categories.map { c ->
        Category(
            id = (c.id as Number).toLong(),
            createdAt = (c.createdAt as String),
            name = (c.name as String),
            color = (c.color as String),
        )
    }

    return groupProductsByCategory(productsList, categoriesList)
}