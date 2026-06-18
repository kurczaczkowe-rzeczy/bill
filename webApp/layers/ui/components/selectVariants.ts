import { cva, type VariantProps } from "class-variance-authority";

export const selectVariants = cva("select transition-colors", {
  variants: {
    color: {
      neutral: "select-neutral",
      primary: "select-primary",
      secondary: "select-secondary",
      accent: "select-accent",
      info: "select-info",
      success: "select-success",
      warning: "select-warning",
      error: "select-error",
      noColor: "",
    },
    appearance: {
      solid: "",
      ghost: "select-ghost",
    },
    size: {
      sm: "select-sm",
      md: "select-md",
      lg: "select-lg",
      xl: "select-xl",
    },
    wide: {
      true: "w-full",
      false: "",
    },
  },

  defaultVariants: {
    color: "primary",
    appearance: "solid",
    wide: true,
  },
});

export type SelectVariants = VariantProps<typeof selectVariants>;

export type UiLayerSelectConfig = Partial<SelectVariants>;

declare module "~/types/ui-layer-registry" {
  interface UiLayerRegistry {
    select: UiLayerSelectConfig;
  }
}
