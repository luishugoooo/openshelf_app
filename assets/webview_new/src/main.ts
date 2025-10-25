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
let isFirstLoad = true;

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
  console.log("INITIALIZING READER:", currentPage, totalPages);
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
  console.log("UPDATING PAGE COUNT:", currentPage, totalPages);
  PageCountChannel.postMessage(
    JSON.stringify({ current: currentPage, total: totalPages })
  );
}

function resetScrollerWidth() {
  if (!scroller) return;
  if (pageWidth > 0) {
    scroller.style.width = `${pageWidth}px`;
  } else {
    scroller.style.removeProperty("width");
  }
}

(window as any).nextPage = function () {
  if (!mask || currentPage >= totalPages) return;
  currentPage++;
  mask.scrollTo({
    left: (currentPage - 1) * pageWidth,
    behavior: "smooth",
  });
  updatePageCount();
};

(window as any).prevPage = function () {
  if (!mask || currentPage <= 1) return;
  currentPage--;
  mask.scrollTo({
    left: (currentPage - 1) * pageWidth,
    behavior: "smooth",
  });
  updatePageCount();
};

(window as any).scrollToPage = function (page: number) {
  if (!mask || page < 1 || page > totalPages) return;
  mask.scrollLeft = (page - 1) * pageWidth;
  currentPage = page;
  updatePageCount();
};

function setupResizeListener() {
  window.addEventListener("resize", () => {
    resetScrollerWidth();
    initializeReader();
  });
}

function setupPaginationControls() {
  mask = document.getElementById("viewer-mask");
  scroller = document.getElementById("viewer-scroller");
  window.addEventListener("load", () => {
    InterfaceControlChannel.postMessage("ready");
  });
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", setupPaginationControls);
} else {
  setupPaginationControls();
}

(window as any).loadBookString = async function (
  content: string,
  anchor: string | null
) {
  console.log("CONTENT FROM JS, length:", content.length);

  const resources: EpubResources = (window as any).epubResources;
  console.log("RESOURCES FROM JS:", resources, new Date().toISOString());

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

  insertContent(processedContent);
  if (anchor) {
    (window as any).scrollToAnchor(anchor);
  }
};

function raf(): Promise<void> {
  return new Promise((resolve) => requestAnimationFrame(() => resolve()));
}

async function waitForNonZeroPageWidth(maxFrames = 60): Promise<number> {
  let width = computePageWidth();
  for (let i = 0; i < maxFrames && width <= 0; i++) {
    await raf();
    width = computePageWidth();
  }
  return width;
}

async function waitForImagesToLoad(container: HTMLElement, timeoutMs = 3000) {
  const images = Array.from(container.querySelectorAll("img"));
  if (images.length === 0) return;
  await Promise.race([
    Promise.all(
      images.map((img) =>
        img.complete
          ? Promise.resolve()
          : new Promise<void>((resolve) => {
              const done = () => {
                img.removeEventListener("load", done);
                img.removeEventListener("error", done);
                resolve();
              };
              img.addEventListener("load", done, { once: true });
              img.addEventListener("error", done, { once: true });
            })
      )
    ),
    new Promise<void>((resolve) => setTimeout(resolve, timeoutMs)),
  ]);
}

async function insertContent(content: string) {
  if (!scroller) return;
  resetScrollerWidth();
  scroller.innerHTML = content;

  // Ensure viewport has a non-zero width (important on first load in WebViews)
  await waitForNonZeroPageWidth(60);
  // Give the browser a frame to apply DOM changes
  await raf();

  // If images are present, wait briefly for them (data URIs resolve fast)
  await waitForImagesToLoad(scroller);

  initializeReader();
  ContentControlChannel.postMessage("loaded");

  // Setup resize listener only after first initialization to avoid double init
  if (isFirstLoad) {
    isFirstLoad = false;
    setupResizeListener();
  }
}

(window as any).scrollToAnchor = function (anchor: string) {
  if (!anchor) return;
  let element = document.getElementById(anchor);
  if (!element) {
    console.log("ELEMENT NOT FOUND:", anchor);
    return;
  }
  //TODO: Sometimes the calculation is a bit off, figure it out
  let elementPage = Math.ceil(element.offsetLeft / pageWidth);
  if (elementPage < 1) {
    elementPage = 1;
  }
  if (elementPage > totalPages) {
    elementPage = totalPages;
  }
  (window as any).scrollToPage(elementPage);
};
