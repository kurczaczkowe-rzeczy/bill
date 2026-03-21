import { fileURLToPath } from "node:url";
import { defineNuxtConfig } from "nuxt/config";
export default defineNuxtConfig({
  components: [
    {
      path: "~/components",
      pathPrefix: false,
    },
  ],
  alias: {
    "@ui": fileURLToPath(new URL(".", import.meta.url)),
  },
});
