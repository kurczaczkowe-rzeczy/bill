import { UnitEnum } from '@bill/Bill-shoppingList'
import { assertValueIsDefined } from '~/utils/assertValueIsDefined'

export function ktUnitEnumToString( value: any ) {
  assertValueIsDefined( value )

  if ( isKtUnitEnum( value ) ) {
    return value.name as string
  }

  throw new Error( 'value is not a UnitEnum type' )
}

export function isKtUnitEnum( value: any ): boolean {
   return value instanceof UnitEnum
}