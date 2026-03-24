import type { UiLayerConfig } from "~/types/ui-layer-config.types";

declare module "nuxt/schema" {
  interface AppConfigInput {
    ui?: UiLayerConfig;
  }
  interface AppConfig {
    ui: UiLayerConfig;
  }
}
