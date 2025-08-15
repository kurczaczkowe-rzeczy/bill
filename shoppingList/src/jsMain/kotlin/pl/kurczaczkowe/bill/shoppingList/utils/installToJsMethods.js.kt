package pl.kurczaczkowe.bill.shoppingList.utils

import pl.kurczaczkowe.bill.shoppingList.dto.Category
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingList
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingListDesc
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingListDetails
import pl.kurczaczkowe.bill.shoppingList.dto.toJs
import kotlin.js.unsafeCast

private fun ensureMethod(ctor: dynamic, f: (dynamic) -> dynamic) {
    val has = js("typeof ctor.prototype.toJs !== 'undefined'").unsafeCast<Boolean>()
    if (!has) {
        ctor.prototype.toJs = { f(js("this")) }
    }
}


@JsExport
@JsName("installToJsMethods")
fun installToJsMethods() {
    val shoppingListCtor: dynamic = ShoppingList::class.js
    val shoppingListDescCtor: dynamic = ShoppingListDesc::class.js
    val shoppingListDetailsCtor: dynamic = ShoppingListDetails::class.js
    val categoryCtor: dynamic = Category::class.js

    ensureMethod(shoppingListCtor) { self -> self.unsafeCast<ShoppingList>().toJs() }
    ensureMethod(shoppingListDescCtor) { self -> self.unsafeCast<ShoppingListDesc>().toJs() }
    ensureMethod(shoppingListDetailsCtor) { self -> self.unsafeCast<ShoppingListDetails>().toJs() }
    ensureMethod(categoryCtor) { self -> self.unsafeCast<Category>().toJs() }
}