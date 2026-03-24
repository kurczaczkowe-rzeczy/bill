import { cva, type VariantProps } from "class-variance-authority";

export const buttonVariants = cva("btn transition-colors", {
  variants: {
    color: {
      neutral: "btn-neutral",
      primary: "btn-primary",
      secondary: "btn-secondary",
      accent: "btn-accent",
      info: "btn-info",
      success: "btn-success",
      warning: "btn-warning",
      error: "btn-error",
      noColor: "",
    },
    appearance: {
      solid: "",
      ghost: "btn-ghost",
      link: "btn-link",
      outline: "btn-outline",
      soft: "btn-soft",
    },
    circle: { true: "btn-circle", false: "" },
    square: { true: "btn-square", false: "" },
    disabled: { true: "btn-disabled", false: "" },
    size: {
      sm: "btn-sm",
      md: "btn-md",
      lg: "btn-lg",
      xl: "btn-xl",
    },
    modifier: {
      wide: "btn-wide",
      block: "btn-block",
    },
  },

  defaultVariants: {
    color: "primary",
    appearance: "solid",
  },
});

export type ButtonVariants = VariantProps<typeof buttonVariants>;

export type UiLayerButtonConfig = Partial<ButtonVariants>;

declare module "~/types/ui-layer-registry" {
  interface UiLayerRegistry {
    button: UiLayerButtonConfig;
  }
}
