import type { UiLayerRegistry } from "~/types/ui-layer-registry";

export type UiLayerConfig = {
  [K in keyof UiLayerRegistry]?: UiLayerRegistry[K];
};
