import { cva, type VariantProps } from "class-variance-authority";

export const radioVariants = cva("radio transition-colors", {
  variants: {
    color: {
      neutral: "radio-neutral",
      primary: "radio-primary",
      secondary: "radio-secondary",
      accent: "radio-accent",
      info: "radio-info",
      success: "radio-success",
      warning: "radio-warning",
      error: "radio-error",
      noColor: "",
    },
    size: {
      sm: "radio-sm",
      md: "radio-md",
      lg: "radio-lg",
      xl: "radio-xl",
    },
  },
  defaultVariants: {
    color: "primary",
  },
});

export type RadioVariants = VariantProps<typeof radioVariants>;

export type UiLayerRadioConfig = Partial<RadioVariants>;

declare module "~/types/ui-layer-registry" {
  interface UiLayerRegistry {
    radio: UiLayerRadioConfig;
  }
}
