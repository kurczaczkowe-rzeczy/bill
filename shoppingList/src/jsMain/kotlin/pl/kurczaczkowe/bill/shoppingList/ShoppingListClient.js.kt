package pl.kurczaczkowe.bill.shoppingList

import io.github.jan.supabase.realtime.Column
import io.github.jan.supabase.realtime.PostgresAction
import io.github.jan.supabase.realtime.decodeOldRecordOrNull
import io.github.jan.supabase.realtime.decodeRecordOrNull
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.time.ExperimentalTime

@JsExport
class Subscription internal constructor(private val scope: CoroutineScope) {
    fun unsubscribe() {
        scope.cancel()
    }
}

@JsExport
fun ShoppingListClient.listenForChangesShoppingList(
    listId: Long,
    action: (PostgresAction) -> Unit
): Subscription {
    val scope = MainScope()

    scope.launch {
        listenForChangesShoppingList(
            action = action,
            scope = scope,
            listId = listId
        )
    }

    return Subscription( scope = scope )
}

private fun ensureMethod(ctor: dynamic, f: (dynamic, Number, (payload: dynamic) -> dynamic) -> dynamic) {
    val has = js("typeof ctor.prototype.listenForChangesShoppingList !== 'undefined'").unsafeCast<Boolean>()
    if (!has) {
        ctor.prototype.listenForChangesShoppingList = { listId: Long, action: (payload: dynamic) -> dynamic ->
            f(js("this"), listId, action)
        }
    }
}

@JsExport
data class JsPostgresAction(
    @JsName("columns")
    val columns: Array<Column>,
    @JsName("commitTimestamp")
    val commitTimestamp: String,
    @JsName("record")
    val record: ShoppingListDetail?,
    @JsName("oldRecord")
    val oldRecord: ShoppingListDetail?,
)

@OptIn(ExperimentalTime::class)
@JsExport
@JsName("installListenForChangesShoppingListMethod")
fun installListenForChangesShoppingListMethod() {
    val shoppingListClientCtor: dynamic = ShoppingListClient::class.js

    ensureMethod(shoppingListClientCtor) { self, listId, action ->
        self.unsafeCast<ShoppingListClient>().listenForChangesShoppingList(action = { payload ->
            println("Received action: ${(payload as PostgresAction.Update).oldRecord}")
            val jsPayload = JsPostgresAction(
                commitTimestamp = payload.commitTimestamp.toString(),
                record = (payload as PostgresAction.Update).decodeRecordOrNull<ShoppingListDetail>(),
                oldRecord = payload.decodeOldRecordOrNull<ShoppingListDetail>(),
                columns = payload.columns.toTypedArray()
            )
            action(jsPayload)
        },
            listId = listId.toLong(),
        )

    }
}
@JsExport
@Serializable
data class ShoppingListDetail(
    @SerialName("_id") val id: Long,
    @SerialName("_quantity") val quantity: Int? = null,
    @SerialName("_product_id") val productId: Long? = null,
    @SerialName("_in_cart") val inCart: Boolean? = null,
    @SerialName("_category_id") val categoryId: Long? = null,
)