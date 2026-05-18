import { cva, type VariantProps } from "class-variance-authority";

export const labelVariants = cva("transition-colors", {
  variants: {
    floating: {
      true: "floating-label", false: "label"
    },
  },

  defaultVariants: {
    floating: false,
  },
});

export type LabelVariants = VariantProps<typeof labelVariants>;

export type UiLayerLabelConfig = Partial<LabelVariants>;

declare module "~/types/ui-layer-registry" {
  interface UiLayerRegistry {
    label: UiLayerLabelConfig;
  }
}
