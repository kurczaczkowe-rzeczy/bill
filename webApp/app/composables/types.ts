import type { Subscription } from "@bill/Bill-shoppingList";

import type { KtClientDataOptions } from "~/composables/useKtClientData";

export type Channels = Map<string, Subscription>;

export interface AsyncDataWithTimestamp<TData> {
  result: TData;
  fetchedAt?: number;
}

export interface ClientOptions<TAsyncData, TClient> extends KtClientDataOptions<TAsyncData> {
  client?: TClient;
}

export interface ClientOptionsWithAutoListener<TAsyncData, TClient, TListenerType>
  extends ClientOptions<TAsyncData, TClient> {
  useAutoListenFor?: MaybeRefOrGetter<TListenerType>;
}
