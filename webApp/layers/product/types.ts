import type { DisplayUnit, Product } from "@bill/packages/Bill-shoppingList";

export interface ProductSuggestion extends Omit<Product, "baseUnit"> {
  baseUnit: DisplayUnit;
}
