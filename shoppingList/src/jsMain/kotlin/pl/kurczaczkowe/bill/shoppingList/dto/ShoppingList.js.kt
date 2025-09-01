package pl.kurczaczkowe.bill.shoppingList.dto

@JsExport
@JsName("shoppingListToJs")
fun ShoppingList.toJs(): dynamic {
    val id = this.id
    val createdAt = this.createdAt
    val date = this.date
    val name = this.name
    val productAmount = this.productAmount

    return js("""{
        "id": id,
        "createdAt": createdAt,
        "date": date,
        "name": name,
        "productAmount": productAmount
    }""")
}
