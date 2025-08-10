import "./style.css";

declare const EpubChannel: { postMessage: (msg: string) => void } | undefined;

console.log("main.ts file loaded");
const appEl = document.querySelector<HTMLDivElement>("#app");
if (appEl) {
  appEl.innerHTML = `
  <div>
    <h1>EPUB Reader</h1>
    <p>
      This is an epub reader.
    </p>
  </div>
`;
}

// Internal API (not attached to window)
(window as any).test = function () {
  console.log("TEST");
  try {
    EpubChannel?.postMessage("TEST");
  } catch (e) {
    console.warn("EpubChannel not available", e);
  }
};
