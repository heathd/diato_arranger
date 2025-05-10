import { defineConfig } from 'vite';

export default defineConfig({
  server: {
    port: 5173,
    proxy: {
      '/api': {
        target: 'http://localhost:9292',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, '')
      }
    }
  },
  build: {
    outDir: 'static/dist',
    emptyOutDir: true,
    rollupOptions: {
      input: {
        main: 'src/main.js'
      }
    }
  }
}); 