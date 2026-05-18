import { cva, type VariantProps } from "class-variance-authority";

export const textareaVariants = cva("textarea transition-colors", {
  variants: {
    color: {
      neutral: "textarea-neutral",
      primary: "textarea-primary",
      secondary: "textarea-secondary",
      accent: "textarea-accent",
      info: "textarea-info",
      success: "textarea-success",
      warning: "textarea-warning",
      error: "textarea-error",
      noColor: "",
    },
    appearance: {
      solid: "",
      ghost: "textarea-ghost",
    },
    size: {
      sm: "textarea-sm",
      md: "textarea-md",
      lg: "textarea-lg",
      xl: "textarea-xl",
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

export type TextareaVariants = VariantProps<typeof textareaVariants>;

export type UiLayerTextareaConfig = Partial<TextareaVariants>;

declare module "~/types/ui-layer-registry" {
  interface UiLayerRegistry {
    textarea: UiLayerTextareaConfig;
  }
}
