/**
 * CSS column-based pagination reader.
 *
 * Problem: Viewport units (100vw) resolve to fractional pixel values (e.g., 411.67px).
 * CSS columns lay out at fractional widths while scrollLeft operates in integer pixels.
 * Scrolling by mask.clientWidth truncates fractional parts, causing cumulative drift
 * over multiple pages (~4px over 50 pages).
 *
 * Solution: Compute an integer pixel page width from getBoundingClientRect().width,
 * set CSS variable --page-width to this value, then use the same integer for both
 * column-width (via CSS var) and scrollLeft increments. This ensures layout and
 * navigation use identical discrete pixel boundaries, eliminating rounding drift.
 *
 * Flow:
 * 1. computePageWidth() measures mask's rendered width and rounds to integer pixels
 * 2. applyPageWidth() sets --page-width CSS var on scroller
 * 3. requestAnimationFrame ensures layout commits before measuring scrollWidth
 * 4. totalPages = ceil(scrollWidth / pageWidth), scroller.style.width = totalPages * pageWidth
 * 5. Navigation scrolls by exact pageWidth increments
 */

interface EpubResources {
  css: Record<string, string>;
  images: Record<string, string>;
}

let mask: HTMLElement | null;
let scroller: HTMLElement | null;

let currentPage = 1;
let totalPages = 1;
let pageWidth = 0;

function computePageWidth(): number {
  if (!mask) return 0;
  const rectWidth = mask.getBoundingClientRect().width;
  return Math.round(rectWidth);
}

function applyPageWidth() {
  if (!scroller) return;
  pageWidth = computePageWidth();
  (scroller.style as any).setProperty("--page-width", `${pageWidth}px`);
}

function initializeReader() {
  if (!mask || !scroller) return;

  applyPageWidth();

  const scrollerEl = scroller;
  const maskEl = mask;
  requestAnimationFrame(() => {
    if (!scrollerEl || !maskEl) return;
    const contentWidth = scrollerEl.scrollWidth;
    totalPages = Math.max(1, Math.ceil(contentWidth / pageWidth));
    scrollerEl.style.width = `${totalPages * pageWidth}px`;
    currentPage = Math.min(currentPage, totalPages);
    maskEl.scrollLeft = (currentPage - 1) * pageWidth;
    updatePageCount();
  });
}

function updatePageCount() {
  PageCountChannel.postMessage(
    JSON.stringify({ current: currentPage, total: totalPages })
  );
}

(window as any).nextPage = function () {
  if (!mask || currentPage >= totalPages) return;
  currentPage++;
  mask.scrollLeft = (currentPage - 1) * pageWidth;
  updatePageCount();
};

(window as any).prevPage = function () {
  if (!mask || currentPage <= 1) return;
  currentPage--;
  mask.scrollLeft = (currentPage - 1) * pageWidth;
  updatePageCount();
};

function setupPaginationControls() {
  mask = document.getElementById("viewer-mask");
  scroller = document.getElementById("viewer-scroller");
  window.addEventListener("load", initializeReader);
  window.addEventListener("resize", initializeReader);
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", setupPaginationControls);
} else {
  setupPaginationControls();
}

(window as any).loadBookString = async function (content: string) {
  console.log("CONTENT FROM JS, length:", content.length);

  const resources: EpubResources = (window as any).epubResources;

  if (resources?.css) {
    console.log("Applying CSS files:", Object.keys(resources.css).length);
    Object.entries(resources.css).forEach(([filename, cssContent]) => {
      const style = document.createElement("style");
      style.setAttribute("data-source", filename);
      style.textContent = cssContent;
      document.head.appendChild(style);
    });
  }

  let processedContent = content;
  if (resources?.images) {
    console.log("Processing images:", Object.keys(resources.images).length);
    Object.entries(resources.images).forEach(([path, dataUri]) => {
      const fileName = path.split("/").pop() || path;
      const patterns = [
        new RegExp(`src=["'].*?${fileName.replace(".", "\\.")}["']`, "gi"),
        new RegExp(`src=["']${path.replace(/\//g, "\\/")}["']`, "gi"),
      ];
      patterns.forEach((pattern) => {
        processedContent = processedContent.replace(
          pattern,
          `src="${dataUri}"`
        );
      });
    });
  }

  if (scroller) {
    scroller.innerHTML = processedContent;
  }
  console.log("Book loaded successfully");

  setTimeout(initializeReader, 100);
};

(window as any).test = async function () {
  console.log("TEST FROM JS");
};
