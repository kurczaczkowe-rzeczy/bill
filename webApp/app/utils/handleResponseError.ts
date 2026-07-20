import type { NetworkError, Result } from "@bill/packages/Bill-shoppingList";

export function handleResponseError<R>(response: Result<R, NetworkError>) {
  if ("error" in response) {
    throw new Error(response as unknown as string);
  }
}
