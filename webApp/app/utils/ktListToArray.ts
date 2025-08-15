import { assertValueIsDefined } from '~/utils/assertValueIsDefined'

export function ktListToArray<Item>(list?: KtList<Item>): Item[] {
  assertValueIsDefined(list)

  if (isKtList(list)) {
    return list.toArray!()
  }

  throw new Error('value is not a KtList type')
}

export function isKtList<T>(value: any): value is KtList<T> {
  return value && typeof value === 'object' && 'toArray' in value && 'asJsReadonlyArrayView' in value && value.toArray && value.asJsReadonlyArrayView
}

export interface KtList<T> {
  toArray?: () => T[]
  asJsReadonlyArrayView?: () => readonly T[]
}