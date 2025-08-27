declare module "@bill/Bill-shoppingList" {
  interface ShoppingListClient {
    listenForShoppingListChanges(
      listId: number,
      action: ListenForShoppingListChangesAction,
    ): Subscription;
  }
  export type ListenForShoppingListChangesAction = (payload: JsPostgresAction) => Promise<void>;
}
