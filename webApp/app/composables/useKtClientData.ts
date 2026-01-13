import type { NetworkError, Result } from "@bill/Bill-core";

import type { AsyncDataOptions } from "#app";
import type { AsyncDataWithTimestamp } from "~/composables/types";
import { readResponse } from "~/utils/readResponse";

export type KtClientDataOptions<TAsyncData> = AsyncDataOptions<AsyncDataWithTimestamp<TAsyncData>>;

const _5_MINUTES = 5 * 60 * 1000;
const TTL = _5_MINUTES;

export function useKtClientData<TAsyncData>(
  key: MaybeRefOrGetter<string>,
  handler: () => Promise<Result<TAsyncData, NetworkError>>,
  options?: KtClientDataOptions<TAsyncData>,
) {
  const result = useAsyncData(
    key,
    async () => {
      const response = await handler();

      return readResponse<TAsyncData>(response, { returnWithFetchedAt: true });
    },
    {
      getCachedData(key, nuxtApp) {
        const cached = nuxtApp.payload.data[key] || nuxtApp.static.data[key];

        if (!cached || Date.now() > cached.fetchedAt + TTL) return undefined;

        return cached;
      },
      server: false,
      dedupe: "defer",
      ...options,
    },
  );

  return {
    ...result,
    data: computed(() => result.data.value?.result),
  };
}
