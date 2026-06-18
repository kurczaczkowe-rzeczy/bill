import { cva, type VariantProps } from "class-variance-authority";

export const cardVariants = cva("transition-colors card", {
  variants: {
    appearance: {
      border: "card-border",
      dash: "card-dash",
    },
    size: {
      xs: "card-xs",
      sm: "card-sm",
      md: "card-md",
      lg: "card-lg",
      xl: "card-xl",
    },
  },

  defaultVariants: {},
});

export type CardVariants = VariantProps<typeof cardVariants>;

export type UiLayerCardConfig = Partial<CardVariants>;

declare module "~/types/ui-layer-registry" {
  interface UiLayerRegistry {
    card: UiLayerCardConfig;
  }
}
