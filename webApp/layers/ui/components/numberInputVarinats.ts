import { cva, type VariantProps } from "class-variance-authority";

export const numberInputVariants = cva("input transition-colors", {
  variants: {
    color: {
      neutral: "input-neutral",
      primary: "input-primary",
      secondary: "input-secondary",
      accent: "input-accent",
      info: "input-info",
      success: "input-success",
      warning: "input-warning",
      error: "input-error",
      noColor: "",
    },
    appearance: {
      solid: "",
      ghost: "input-ghost",
    },
    size: {
      sm: "input-sm",
      md: "input-md",
      lg: "input-lg",
      xl: "input-xl",
    },
    wide: {
      true: "w-full", false: ""
    },
  },

  defaultVariants: {
    color: "primary",
    appearance: "solid",
  },
});

export type NumberInputVariants = VariantProps<typeof numberInputVariants>;

export type UiLayerNumberInputConfig = Partial<NumberInputVariants>;

declare module "~/types/ui-layer-registry" {
  interface UiLayerRegistry {
    numberInput: UiLayerNumberInputConfig;
  }
}
