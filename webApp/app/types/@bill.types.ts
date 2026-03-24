declare module "@bill/Bill-shoppingList" {
  interface ShoppingListClient {
    listenForShoppingListChanges(
      listId: bigint,
      action: ListenForShoppingListChangesAction,
    ): Subscription;
    listenForShoppingListsChanges(action: ListenForShoppingListsChangesAction): Subscription;
  }
  export type ListenForShoppingListChangesAction = (
    payload:
      | JsPostgresAction<ShoppingListRow, null>
      | JsPostgresAction<ShoppingListRow, EntityId>
      | JsPostgresAction<null, ShoppingListRow>,
  ) => Promise<void>;
  export type ListenForShoppingListsChangesAction = (
    payload:
      | JsPostgresAction<ShoppingList, null>
      | JsPostgresAction<ShoppingList, EntityId>
      | JsPostgresAction<null, EntityId>,
  ) => Promise<void>;
}
