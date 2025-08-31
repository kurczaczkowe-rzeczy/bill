@file:JsExport
package pl.kurczaczkowe.bill.shoppingList.dto

import io.github.jan.supabase.realtime.Column

data class JsPostgresAction<Record, OldRecord>(
    @JsName("columns")
    val columns: Array<Column>,
    @JsName("commitTimestamp")
    val commitTimestamp: String,
    @JsName("record")
    val record: Record? = null,
    @JsName("oldRecord")
    val oldRecord: OldRecord? = null,
)