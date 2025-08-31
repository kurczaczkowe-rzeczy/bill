declare module "@bill/Bill-shoppingList" {
  interface ShoppingListClient {
    listenForShoppingListChanges(
      listId: number,
      action: ListenForShoppingListChangesAction,
    ): Subscription;
    listenForShoppingListsChanges(action: ListenForShoppingListsChangesAction): Subscription;
  }
  export type ListenForShoppingListChangesAction = (
    payload:
      | JsPostgresAction<ShoppingListDetail, null>
      | JsPostgresAction<ShoppingListDetail, EntityId>
      | JsPostgresAction<null, ShoppingListDetail>,
  ) => Promise<void>;
  export type ListenForShoppingListsChangesAction = (
    payload:
      | JsPostgresAction<ShoppingList, null>
      | JsPostgresAction<ShoppingList, EntityId>
      | JsPostgresAction<null, EntityId>,
  ) => Promise<void>;
}
