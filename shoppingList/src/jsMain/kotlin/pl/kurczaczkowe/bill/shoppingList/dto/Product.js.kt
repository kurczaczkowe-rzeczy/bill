package pl.kurczaczkowe.bill.shoppingList.dto

@JsExport
@JsName("productToJs")
fun Product.toJs(): dynamic {
    val id = this.id
    val createdAt = this.createdAt
    val name = this.name
    val unit = this.unit

    return js("""{
        "id": id,
        "createdAt": createdAt,
        "name": name,
        "unit": unit,
    }""")
}
