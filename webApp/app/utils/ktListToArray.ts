import { assertValueIsDefined } from "~/utils/assertValueIsDefined";

export function ktListToArray<Item>(list?: KtList<Item>): Item[] {
  assertValueIsDefined(list);

  if (isKtList(list)) {
    return list.toArray?.() ?? [];
  }

  throw new Error("value is not a KtList type");
}

export function isKtList<T>(value: unknown): value is KtList<T> {
  return !!value && typeof value === "object" && "toArray" in value && !!value.toArray;
}

export interface KtList<T> {
  toArray?: () => T[];
  asJsReadonlyArrayView?: () => readonly T[];
}
