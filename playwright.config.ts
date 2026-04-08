import { defineConfig } from "@playwright/test";

export default defineConfig({
  use: {
    headless: true,
    baseURL: "https://tu-app.com",
  },
  retries: 1,
});
