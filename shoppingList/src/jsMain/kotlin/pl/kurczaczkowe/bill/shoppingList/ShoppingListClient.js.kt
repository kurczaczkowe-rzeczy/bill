package pl.kurczaczkowe.bill.shoppingList

import io.github.jan.supabase.realtime.PostgresAction
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch
import pl.kurczaczkowe.bill.shoppingList.dto.Subscription

@JsExport
fun ShoppingListClient.listenForShoppingListChanges(
    listId: Long,
    action: (PostgresAction) -> Unit
): Subscription {
    val scope = MainScope()

    scope.launch {
        listenForShoppingListChanges(
            action = action,
            scope = scope,
            listId = listId
        )
    }

    return Subscription(scope = scope)
}

@JsExport
fun ShoppingListClient.listenForShoppingListsChanges(
    listId: Long,
    action: (PostgresAction) -> Unit
): Subscription {
    val scope = MainScope()

    scope.launch {
        listenForShoppingListChanges(
            action = action,
            scope = scope,
            listId = listId
        )
    }

    return Subscription(scope = scope)
}
