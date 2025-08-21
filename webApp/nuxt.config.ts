import tailwindcss from "@tailwindcss/vite";
import { fileURLToPath } from "url";
// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: "2025-07-15",
  devtools: { enabled: true },

  alias: {
    "@bill": fileURLToPath(new URL("../build/js/packages/", import.meta.url)),
  },
  nitro: {
    preset: "github_pages",
  },
  app: {
    baseURL: "/bill/",
  },

  devServer: {
    port: 2137,
  },

  vite: {
    plugins: [tailwindcss()],
  },

  css: ["~/assets/css/app.css"],

  modules: ["@nuxt/icon"],
});
