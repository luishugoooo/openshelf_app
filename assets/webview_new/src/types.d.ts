interface PageCountChannel {
  postMessage(message: string): void;
}

declare var PageCountChannel: PageCountChannel;

interface ContentControlChannel {
  postMessage(message: string): void;
}

interface InterfaceControlChannel {
  postMessage(message: string): void;
}

declare var InterfaceControlChannel: InterfaceControlChannel;

declare var ContentControlChannel: ContentControlChannel;
