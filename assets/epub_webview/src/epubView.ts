import ePub from "@intity/epub-js";
import { Rendition } from "@intity/epub-js";

let book = ePub({});

let rendition: Rendition;
let displayed;
console.log("epubView file loaded");
(window as any).loadBook = async function (blob: Uint8Array) {
  let uint8Array = new Uint8Array(blob);
  await book.open(uint8Array);
  rendition = book.renderTo("reader", {
    height: "100%",
    manager: "default",
    sandbox: ["allow-same-origin", "allow-scripts"],
  });
  displayed = rendition.display();

  displayed.then(() => {
    EpubChannel.postMessage("Book loaded");
  });
};

(window as any).nextPage = function () {
  rendition.next();
};

(window as any).previousPage = function () {
  rendition.prev();
};
