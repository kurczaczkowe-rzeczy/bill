import type { Subscription } from "@bill/Bill-shoppingList";

import type { AsyncDataOptions } from "#app";

export type Channels = Map<string, Subscription>;

export interface ClientOptions<TAsyncData, TListenerType, TClient>
  extends AsyncDataOptions<TAsyncData> {
  useAutoListenFor?: MaybeRefOrGetter<TListenerType>;
  client?: TClient;
}
