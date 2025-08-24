package pl.kurczaczkowe.bill.shoppingList.dto

import io.github.jan.supabase.realtime.Column

@JsExport
data class JsPostgresAction(
    @JsName("columns")
    val columns: Array<Column>,
    @JsName("commitTimestamp")
    val commitTimestamp: String,
    @JsName("record")
    val record: ShoppingListDetail? = null,
    @JsName("oldRecord")
    val oldRecord: ShoppingListDetail? = null,
)