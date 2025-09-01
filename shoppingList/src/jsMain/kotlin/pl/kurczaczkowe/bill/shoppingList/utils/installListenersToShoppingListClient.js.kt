package pl.kurczaczkowe.bill.shoppingList.utils

import io.github.jan.supabase.realtime.PostgresAction
import io.github.jan.supabase.realtime.decodeOldRecord
import io.github.jan.supabase.realtime.decodeRecord
import pl.kurczaczkowe.bill.core.networking.Subscription
import pl.kurczaczkowe.bill.shoppingList.ShoppingListClient
import pl.kurczaczkowe.bill.shoppingList.dto.EntityId
import pl.kurczaczkowe.bill.shoppingList.dto.JsPostgresAction
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingList
import pl.kurczaczkowe.bill.shoppingList.dto.ShoppingListRow
import kotlin.time.ExperimentalTime

private typealias ShoppingListChangeListener = (listId: Number, action: (payload: dynamic) -> dynamic) -> Subscription
private typealias ShoppingListsChangeListener = (action: (payload: dynamic) -> dynamic) -> Subscription


private fun  <T : Function<*>> ensureMethod(ctor: dynamic, funcName: String, f: T) {
    val has = ctor.prototype[funcName] !== undefined
    if (!has) {
        ctor.prototype[funcName] = f
    }
}

@OptIn(ExperimentalTime::class)
@JsExport
@JsName("installListenersToShoppingListClient")
fun installListenersToShoppingListClient() {
    val shoppingListClientCtor: dynamic = ShoppingListClient::class.js

    ensureMethod<ShoppingListChangeListener>(shoppingListClientCtor, "listenForShoppingListChanges") { listId: Number, action: (payload: dynamic) -> dynamic ->
        js("this").unsafeCast<ShoppingListClient>().listenForShoppingListChanges(action = { payload ->
            try {
                val jsPayload = preparePayload<ShoppingListRow>(payload)
                action(jsPayload)
            } catch (e: Exception) {
                println(e)
            }
        },
            listId = listId.toLong(),
        )
    }
    ensureMethod<ShoppingListsChangeListener>(shoppingListClientCtor, "listenForShoppingListsChanges") { action: (payload: dynamic) -> dynamic ->
        js("this").unsafeCast<ShoppingListClient>().listenForShoppingListsChanges(action = { payload ->
            try {
                val jsPayload = preparePayload<ShoppingList>(payload)
                action(jsPayload)
            } catch (e: Exception) {
                println(e)
            }
        })
    }
}

@OptIn(ExperimentalTime::class)
inline fun <reified Record> preparePayload(payload: PostgresAction): JsPostgresAction<out Record, out EntityId> {
    return when (payload) {
        is PostgresAction.Insert -> JsPostgresAction<Record, Nothing>(
            columns = payload.columns.toTypedArray(),
            commitTimestamp = payload.commitTimestamp.toString(),
            record = payload.decodeRecord(),
        )
        is PostgresAction.Update -> JsPostgresAction<Record, EntityId>(
            columns = payload.columns.toTypedArray(),
            commitTimestamp = payload.commitTimestamp.toString(),
            record = payload.decodeRecord(),
            oldRecord = payload.decodeOldRecord(),
        )
        is PostgresAction.Delete -> JsPostgresAction<Nothing, EntityId>(
            columns = payload.columns.toTypedArray(),
            commitTimestamp = payload.commitTimestamp.toString(),
            oldRecord = payload.decodeOldRecord(),
        )
        is PostgresAction.Select -> JsPostgresAction<Record, Nothing>(
            columns = payload.columns.toTypedArray(),
            commitTimestamp = payload.commitTimestamp.toString(),
            record = payload.decodeRecord(),
        )
    }
}