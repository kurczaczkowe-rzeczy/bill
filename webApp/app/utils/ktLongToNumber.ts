import { assertValueIsDefined } from "~/utils/assertValueIsDefined";

export function ktLongToNumber(long: unknown) {
  assertValueIsDefined(long);

  if (isKtLong(long)) {
    return long.valueOf() as number;
  }

  throw new Error("value is not a Long type");
}

export function isKtLong(value: unknown): value is KtLong {
  return !!value && typeof value === "object" && "low_1" in value && "high_1" in value;
}

export interface KtLong {
  low_1: number;
  high_1: number;
  toValue(): number;
}
