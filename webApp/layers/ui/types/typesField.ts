export interface FieldProps {
  name: string;
  required?: boolean;
}

export interface Option<TValue extends string | number = string | number> {
  value: TValue;
  label: string;
}

export type Options = Option[];

export interface BaseInputProps<TValue extends string | number | boolean | (string | number)[]>
  extends FieldProps {
  disabled?: boolean;
  modelValue: TValue;
  class?: string;
}

export type Query = string;
export type Suggestions<T> = T[];

export interface BaseAutocompleteProps<T> {
  modelValue?: Query;
  suggestions: Suggestions<T>;
  isLoading?: boolean;
  placeholder?: string;
  wrapperClass?: string;
  debounceMs?: number;
  labelKey?: string;
  minLengthQuery?: number;
  listId: string;
  matchBy?: (suggestion: T, query: Query) => boolean;
}
