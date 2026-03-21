import { cva, type VariantProps } from "class-variance-authority";

export const buttonVariants = cva("btn transition-colors", {
  variants: {
    color: {
      primary: "btn-primary",
      secondary: "btn-secondary",
      error: "btn-error",
      neutral: "btn-neutral",
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
    color: "neutral",
    appearance: "ghost",
  },
});

export type ButtonVariants = VariantProps<typeof buttonVariants>;
