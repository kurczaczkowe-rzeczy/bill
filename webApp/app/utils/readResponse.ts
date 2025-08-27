import type { NetworkError, Result } from "@bill/Bill-shoppingList";

import { handleResponseError } from "~/utils/handleResponseError";
import { handleResponseSuccess } from "~/utils/handleResponseSuccess";

export function readResponse<R>(response: Result<R, NetworkError>) {
  handleResponseError(response);

  return handleResponseSuccess(response);
}
