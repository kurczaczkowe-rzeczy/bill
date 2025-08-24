package pl.kurczaczkowe.bill.shoppingList.utils

import io.github.jan.supabase.realtime.PostgresAction
import io.github.jan.supabase.realtime.decodeOldRecord
import io.github.jan.supabase.realtime.decodeRecord
import pl.kurczaczkowe.bill.shoppingList.ShoppingListClient
import pl.kurczaczkowe.bill.shoppingList.dto.JsPostgresAction
import pl.kurczaczkowe.bill.shoppingList.listenForShoppingListChanges
import pl.kurczaczkowe.bill.shoppingList.listenForShoppingListsChanges
import kotlin.js.unsafeCast
import kotlin.time.ExperimentalTime

private fun ensureMethod(ctor: dynamic, funcName: String, f: (dynamic, Number, (payload: dynamic) -> dynamic) -> dynamic) {
    val has = ctor.prototype[funcName] !== undefined
    if (!has) {
        ctor.prototype[funcName] = { listId: Long, action: (payload: dynamic) -> dynamic ->
            f(js("this"), listId, action)
        }
    }
}

@OptIn(ExperimentalTime::class)
@JsExport
@JsName("installListenersToShoppingListClient")
fun installListenersToShoppingListClient() {
    val shoppingListClientCtor: dynamic = ShoppingListClient::class.js

    ensureMethod(shoppingListClientCtor, "listenForShoppingListChanges") { self, listId, action ->
        self.unsafeCast<ShoppingListClient>().listenForShoppingListChanges(action = { payload ->
            val jsPayload = preparePayload(payload)
            action(jsPayload)
        },
            listId = listId.toLong(),
        )
    }
    ensureMethod(shoppingListClientCtor, "listenForShoppingListsChanges") { self, listId, action ->
        self.unsafeCast<ShoppingListClient>().listenForShoppingListsChanges(action = { payload ->
            val jsPayload = preparePayload(payload)
            action(jsPayload)
        },
            listId = listId.toLong(),
        )
    }
}

@OptIn(ExperimentalTime::class)
private fun preparePayload(payload: PostgresAction): JsPostgresAction {
    return when (payload) {
        is PostgresAction.Insert -> JsPostgresAction(
            columns = payload.columns.toTypedArray(),
            commitTimestamp = payload.commitTimestamp.toString(),
            record = payload.decodeRecord(),
        )
        is PostgresAction.Update -> JsPostgresAction(
            columns = payload.columns.toTypedArray(),
            commitTimestamp = payload.commitTimestamp.toString(),
            record = payload.decodeRecord(),
            oldRecord = payload.decodeOldRecord(),
        )
        is PostgresAction.Delete -> JsPostgresAction(
            columns = payload.columns.toTypedArray(),
            commitTimestamp = payload.commitTimestamp.toString(),
            oldRecord = payload.decodeOldRecord(),
        )
        is PostgresAction.Select -> JsPostgresAction(
            columns = payload.columns.toTypedArray(),
            commitTimestamp = payload.commitTimestamp.toString(),
            record = payload.decodeRecord(),
        )
    }
}