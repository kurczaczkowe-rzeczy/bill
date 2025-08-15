export function assertValueIsDefined<T>( value: T | undefined | null ): asserts value is T {
  if ( value === undefined || value === null ) {
    throw new Error( 'value is undefined or null' )
  }
}