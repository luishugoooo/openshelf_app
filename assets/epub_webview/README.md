# ePub WebView

This project uses a forked version of epub-js that requires special handling on Windows due to build script compatibility issues.

## Installation

### First Time Setup

1. Install regular dependencies:
   ```bash
   pnpm install
   ```

2. Install epub-js with Windows compatibility fix:
   ```bash
   pnpm run install-epub
   ```

### Development

```bash
# Start development server
pnpm dev

# Build for production
pnpm build
```

## Why the Special Installation?

The `@intity/epub-js` package from GitHub uses Unix-style environment variables in its build scripts (`NODE_ENV=production`) which don't work on Windows. Our solution:

1. Installs the package with `--ignore-scripts` to skip the failing build
2. Automatically patches the scripts to use `cross-env` for Windows compatibility 
3. Builds the package locally

This ensures the package works on all platforms while maintaining reproducibility.

## Reproducible Installation

The `install-epub` script and postinstall logic ensure that:
- Anyone can clone this repo and get a working setup
- The solution works on Windows, macOS, and Linux
- No manual intervention is required after running the install command
