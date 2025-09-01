package pl.kurczaczkowe.bill.shoppingList.dto

@JsExport
@JsName("shoppingListDescToJs")
fun ShoppingListDesc.toJs(): dynamic {
    val id = this.id
    val createdAt = this.createdAt
    val name = this.name
    val date = this.date

    return js("""{
        "id": id,
        "createdAt": createdAt,
        "name": name,
        "date": date,
    }""")
}

