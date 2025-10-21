interface PageCountChannel {
  postMessage(message: string): void;
}

declare var PageCountChannel: PageCountChannel;
