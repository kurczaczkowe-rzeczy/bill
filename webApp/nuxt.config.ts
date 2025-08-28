import tailwindcss from "@tailwindcss/vite";
import { fileURLToPath } from "url";
// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: "2025-07-15",
  devtools: {
    enabled: true,
    vscode: { enabled: false },
    vueDevTools: true,
  },

  extends: ["./layers/ui"],

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

  modules: ["@nuxt/icon", "@vite-pwa/nuxt"],

  pwa: {
    registerType: "prompt",
    base: "/bill/",
    scope: "/bill/",

    manifest: {
      name: "Bill",
      short_name: "Bill",
      description: "App provide fancy way to organize your household budget.",
      theme_color: "#0B0908FF",
      background_color: "#272322FF",
      start_url: "/bill/",
      scope: "/bill/",
      display: "standalone",
      display_override: ["standalone"],
      categories: ["productivity", "finance", "shopping", "personalization", "utilities"],
      icons: [
        {
          src: "icons/icon-128x128.png",
          sizes: "128x128",
          type: "image/png",
        },
        {
          src: "icons/icon-192x192.png",
          sizes: "192x192",
          type: "image/png",
        },
        {
          src: "icons/icon-512x512.png",
          sizes: "512x512",
          type: "image/png",
        },
      ],
    },
    workbox: {
      navigateFallback: "/",
      globPatterns: ["**/*.{js,css,html,png,jpg,jpeg,svg,ico}"],
      maximumFileSizeToCacheInBytes: 8000000,
    },
    devOptions: {
      enabled: true,
      suppressWarnings: true,
      navigateFallbackAllowlist: [/^\/$/],
      type: "module",
    },
  },
});
