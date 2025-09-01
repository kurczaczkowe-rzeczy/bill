package pl.kurczaczkowe.bill.shoppingList.dto

@JsExport
@JsName("categoryToJs")
fun Category.toJs(): dynamic {
    val id = this.id
    val createdAt = this.createdAt
    val color = this.color
    val name = this.name

    return js("""{
        "id": id,
        "createdAt": createdAt,
        "color": color,
        "name": name,
    }""")
}