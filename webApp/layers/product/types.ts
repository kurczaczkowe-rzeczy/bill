import type { DisplayUnit, Product } from "@bill/Bill-shoppingList";

export interface ProductSuggestion extends Omit<Product, "baseUnit"> {
  baseUnit: DisplayUnit;
}
