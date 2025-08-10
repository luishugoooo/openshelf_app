interface EpubChannel {
  postMessage(message: string): void;
}

declare var EpubChannel: EpubChannel;
