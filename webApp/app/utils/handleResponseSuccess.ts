import type { NetworkError, Result } from "@bill/Bill-shoppingList";

import { ktToJs } from "~/utils/ktToJs";

export function handleResponseSuccess<R>(response: Result<R, NetworkError>) {
  if (!("result" in response)) {
    throw new Error(`Unsupported response type: ${response.constructor.name}`);
  }

  return ktToJs(response.result as R);
}
