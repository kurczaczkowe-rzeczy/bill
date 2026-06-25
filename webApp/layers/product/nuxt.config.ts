import { fileURLToPath } from "node:url";

export default defineNuxtConfig({
  alias: {
    "@product": fileURLToPath(new URL(".", import.meta.url)),
  },
  typescript: {
    tsConfig: {
      compilerOptions: {
        lib: ["esnext", "dom"],
      },
    },
  },
});
