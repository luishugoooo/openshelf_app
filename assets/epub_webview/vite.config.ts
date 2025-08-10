import { defineConfig } from "vite";
import { viteSingleFile } from "vite-plugin-singlefile";

export default defineConfig({
  base: "./",
  plugins: [viteSingleFile()],
  build: {
    outDir: "dist",
    rollupOptions: {
      treeshake: {
        moduleSideEffects: (id) => id.includes("/src/"),
      },
    },
  },
});
