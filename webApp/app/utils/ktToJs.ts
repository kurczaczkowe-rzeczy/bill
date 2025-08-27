import { isKtList, type KtList, ktListToArray } from "./ktListToArray";
import { isKtLong, type KtLong, ktLongToNumber } from "./ktLongToNumber";

export type KtToJs<T> = T extends (...args: any) => any
  ? T
  : T extends { toJs: () => infer U }
    ? KtToJs<U>
    : T extends KtList<infer U>
      ? KtToJs<U>[]
      : T extends KtLong
        ? number
        : T extends (infer E)[]
          ? KtToJs<E>[]
          : T extends
                | Date
                | RegExp
                | Map<any, any>
                | Set<any>
                | ArrayBuffer
                | DataView
                | Int8Array
                | Uint8Array
                | Uint8ClampedArray
                | Int16Array
                | Uint16Array
                | Int32Array
                | Uint32Array
                | Float32Array
                | Float64Array
            ? T
            : T extends object
              ? { -readonly [K in keyof T]: KtToJs<T[K]> }
              : T;

export function ktToJs<T>(data: T): KtToJs<T> {
  if (data === null || typeof data !== "object") {
    return data as any;
  }

  if ("toJs" in data && typeof data.toJs === "function") {
    return ktToJs(data.toJs()) as any;
  }

  if (isKtList(data)) {
    const jsArray = ktListToArray(data);
    return jsArray.map((item) => ktToJs(item)) as any;
  }

  if (isKtLong(data)) {
    return ktLongToNumber(data) as any;
  }

  if (Array.isArray(data)) {
    return data.map((item) => ktToJs(item)) as any;
  }

  if (
    data instanceof Date ||
    data instanceof RegExp ||
    data instanceof Map ||
    data instanceof Set ||
    data instanceof ArrayBuffer ||
    ArrayBuffer.isView(data as any)
  ) {
    return data as any;
  }

  const obj = data as Record<string, unknown>;
  for (const key of Object.keys(obj)) {
    const value = obj[key];
    obj[key] = ktToJs(value as any);
  }
  return obj as any;
}
