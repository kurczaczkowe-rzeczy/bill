import { fileURLToPath } from "node:url";

export default defineNuxtConfig({
  alias: {
    "@category": fileURLToPath(new URL(".", import.meta.url)),
  },

  typescript: {
    tsConfig: {
      compilerOptions: {
        lib: ["esnext", "dom"],
      },
    },
  },
});
