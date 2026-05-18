import { cva, type VariantProps } from "class-variance-authority";

export const checkboxVariants = cva("checkbox transition-colors", {
  variants: {
    color: {
      neutral: "checkbox-neutral",
      primary: "checkbox-primary",
      secondary: "checkbox-secondary",
      accent: "checkbox-accent",
      info: "checkbox-info",
      success: "checkbox-success",
      warning: "checkbox-warning",
      error: "checkbox-error",
      noColor: "",
    },
    size: {
      sm: "checkbox-sm",
      md: "checkbox-md",
      lg: "checkbox-lg",
      xl: "checkbox-xl",
    },
  },
  defaultVariants: {
    color: "primary",
  },
});

export type CheckboxVariants = VariantProps<typeof checkboxVariants>;

export type UiLayerCheckboxConfig = Partial<CheckboxVariants>;

declare module "~/types/ui-layer-registry" {
  interface UiLayerRegistry {
    checkbox: UiLayerCheckboxConfig;
  }
}
