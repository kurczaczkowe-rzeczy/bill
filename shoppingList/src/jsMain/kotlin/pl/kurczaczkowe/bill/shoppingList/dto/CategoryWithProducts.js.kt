package pl.kurczaczkowe.bill.shoppingList.dto

@JsExport
@JsName("categoryWithProductsToJs")
fun CategoryWithProducts.toJs(): dynamic {
    val category = this.category.toJs()
    val products = this.products.map { it.toJs() }.toTypedArray()
    return js("""{
        "category": category,
        "products": products,
    }""")
}
