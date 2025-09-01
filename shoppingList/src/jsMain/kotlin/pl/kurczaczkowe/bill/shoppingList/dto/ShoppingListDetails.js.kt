package pl.kurczaczkowe.bill.shoppingList.dto

@JsExport
@JsName("shoppingListDetailsToJs")
fun ShoppingListDetails.toJs(): dynamic {
    val id = this.id
    val createdAt = this.createdAt
    val quantity = this.quantity
    val unit = this.unit.toJs()
    val name = this.name
    val inCart = this.inCart
    val category = this.category.toJs()

    return js("""{
        "id": id,
        "createdAt": createdAt,
        "quantity": quantity,
        "unit": unit,
        "name": name,
        "inCart": inCart,
        "category": category,
    }""")
}