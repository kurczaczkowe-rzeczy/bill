export function getStringParam(param: unknown): string {
  const preparedParam = Array.isArray(param) ? param[0] : param;

  if (preparedParam === undefined || preparedParam === null) {
    throw new Error(
      `Invalid parameter. It should be a string or number. Actual value: ${preparedParam}`,
    );
  }

  return preparedParam;
}
