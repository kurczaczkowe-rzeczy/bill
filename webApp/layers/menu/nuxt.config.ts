export default defineNuxtConfig({
  typescript: {
    tsConfig: {
      compilerOptions: {
        lib: ["esnext", "dom"],
      },
    },
  },
});
