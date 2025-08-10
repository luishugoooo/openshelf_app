import ePub from "@intity/epub-js";

let book = ePub();
let rendition;
let displayed;

export function loadBook(blob: Uint8Array) {
  let uint8Array = new Uint8Array(blob);
  book.open(uint8Array);
  rendition = book.renderTo("viewer", {
    height: "100vh",
    width: "100vw",
    sandbox: ["allow-same-origin", "allow-scripts"],
  });
  displayed = rendition.display();

  displayed.then(() => {
    console.log("Book loaded");
    //readyToLoad();
  });
}
