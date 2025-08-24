package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.cancel

@JsExport
class Subscription internal constructor(private val scope: CoroutineScope) {
    fun unsubscribe() {
        scope.cancel()
    }
}