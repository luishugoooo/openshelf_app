#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");

/**
 * Postinstall script to fix @intity/epub-js Windows compatibility
 * This script automatically fixes the Unix-style environment variables in the build scripts
 */

const isWindows = process.platform === "win32";
const epubJsPath = path.join(__dirname, "../node_modules/@intity/epub-js");
const packageJsonPath = path.join(epubJsPath, "package.json");

console.log("🔧 Running postinstall script for @intity/epub-js...");

// Check if @intity/epub-js is installed
if (!fs.existsSync(packageJsonPath)) {
  console.log("ℹ️  @intity/epub-js not found.");
  console.log("📋 To install epub-js, run: pnpm run install-epub");
  process.exit(0);
}

try {
  // Read the package.json
  const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, "utf8"));

  // Check if we need to fix the scripts (only on Windows or if scripts are not already fixed)
  const needsFix = !packageJson.scripts.build.includes("cross-env");

  if (needsFix) {
    console.log(
      "🛠️  Fixing Windows compatibility for @intity/epub-js scripts..."
    );

    // Install cross-env in the epub-js package if on Windows
    if (isWindows) {
      console.log("📦 Installing cross-env...");
      execSync("npm install cross-env", { cwd: epubJsPath, stdio: "inherit" });
    }

    // Fix the scripts
    packageJson.scripts.start = packageJson.scripts.start.replace(
      "NODE_ENV=development",
      "cross-env NODE_ENV=development"
    );
    packageJson.scripts.build = packageJson.scripts.build.replace(
      "NODE_ENV=production",
      "cross-env NODE_ENV=production"
    );
    packageJson.scripts.minify = packageJson.scripts.minify.replace(
      "NODE_ENV=production MINIMIZE=true",
      "cross-env NODE_ENV=production MINIMIZE=true"
    );

    // Write the fixed package.json
    fs.writeFileSync(packageJsonPath, JSON.stringify(packageJson, null, 2));

    console.log("✅ Fixed package.json scripts");

    // Build the package (only compilation, skip webpack build)
    console.log("🔨 Compiling @intity/epub-js (this is all we need)...");
    execSync("npm run compile", { cwd: epubJsPath, stdio: "inherit" });

    console.log("🎉 @intity/epub-js is ready to use!");
  } else {
    console.log("✅ @intity/epub-js scripts are already fixed");
  }
} catch (error) {
  console.error("❌ Error fixing @intity/epub-js:", error.message);
  process.exit(1);
}
