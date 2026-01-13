import type { NetworkError, Result } from "@bill/Bill-shoppingList";

import type { AsyncDataWithTimestamp } from "~/composables/types";
import { handleResponseError } from "~/utils/handleResponseError";
import {
  handleResponseSuccess,
  handleResponseSuccessWithFetchedAt,
} from "~/utils/handleResponseSuccess";

interface ReadResponseOptions {
  returnWithFetchedAt?: boolean;
}

export function readResponse<TResult>(
  response: Result<TResult, NetworkError>,
  options: { returnWithFetchedAt: true },
): AsyncDataWithTimestamp<TResult>;
export function readResponse<TResult>(
  response: Result<TResult, NetworkError>,
  options?: { returnWithFetchedAt?: false },
): TResult;
export function readResponse<TResult>(
  response: Result<TResult, NetworkError>,
  options?: ReadResponseOptions,
): AsyncDataWithTimestamp<TResult> | TResult {
  handleResponseError(response);

  return options?.returnWithFetchedAt
    ? handleResponseSuccessWithFetchedAt<TResult>(response)
    : handleResponseSuccess<TResult>(response);
}
