import type { NetworkError, Result } from "@bill/Bill-shoppingList";

import type { AsyncDataWithTimestamp } from "~/composables/types";
import { ktToJs } from "~/utils/ktToJs";

export function handleResponseSuccess<TResult>(response: Result<TResult, NetworkError>): TResult {
  if (!("result" in response)) {
    throw new Error(`Unsupported response type: ${response.constructor.name}`);
  }

  return ktToJs(response.result) as TResult;
}

export function handleResponseSuccessWithFetchedAt<TResult>(
  response: Result<TResult, NetworkError>,
): AsyncDataWithTimestamp<TResult> {
  if (!("result" in response)) {
    throw new Error(`Unsupported response type: ${response.constructor.name}`);
  }

  const result = ktToJs(response.result as TResult);

  return { result, fetchedAt: Date.now() } as AsyncDataWithTimestamp<TResult>;
}
