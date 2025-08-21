import { assertValueIsDefined } from "~/utils/assertValueIsDefined";

export function ktLongToNumber(long: any) {
  assertValueIsDefined(long);

  if (isKtLong(long)) {
    return long.valueOf() as number;
  }

  throw new Error("value is not a Long type");
}

export function isKtLong(value: any): boolean {
  return value && typeof value === "object" && "low_1" in value && "high_1" in value;
}

export interface KtLong {
  low_1: number;
  high_1: number;
  toValue(): number;
}
