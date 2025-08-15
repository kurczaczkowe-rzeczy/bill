import { ShoppingList } from '@bill/Bill-shoppingList';
import { isKtUnitEnum, ktUnitEnumToString } from '~/utils/ktUnitEnumToString'
import { isKtList, ktListToArray, type KtList } from './ktListToArray'
import { isKtLong, ktLongToNumber, type KtLong } from './ktLongToNumber'

export type KtToJs<T> = T extends KtList<infer U>
  ? KtToJs<U>[]
  : T extends KtLong
    ? number
    : T extends (infer E)[]
      ? KtToJs<E>[]
      : T extends object
        ? { -readonly [K in keyof T]: KtToJs<T[K]> }
        : T;

export function ktToJs<T>(data: T): KtToJs<T> {
  if (data === null || typeof data !== 'object') {
    return data as any
  }

  if ('toJs' in data && typeof data.toJs === 'function') {
    return ktToJs(data.toJs()) as any
  }

  if (isKtUnitEnum(data)) {
    return ktUnitEnumToString(data) as any
  }
  if (isKtList(data)) {
    const jsArray = ktListToArray(data as any)
    return jsArray.map(item => ktToJs(item)) as any
  }

  if (isKtLong(data)) {
    return ktLongToNumber(data) as any
  }

  if (Array.isArray(data)) {
    return data.map(item => ktToJs(item)) as any
  }

  if (
    data instanceof Date ||
    data instanceof RegExp ||
    data instanceof Map ||
    data instanceof Set ||
    data instanceof ArrayBuffer ||
    ArrayBuffer.isView(data as any)
  ) {
    return data as any
  }

  const obj = data as Record<string, unknown>
  for (const key of Object.keys(obj)) {
    const value = obj[key]
    obj[key] = ktToJs(value as any)
  }
  return data as any

}