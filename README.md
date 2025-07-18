# Official OpenShelf app for all major platforms 

## Supported Platforms
- Android
- iOS
- macOS
- Windows
- Linux (Experimental)

## Feautures
- Extensive sync and offline support for a smooth reading experience on all platforms
- Manage your books, shelves and library from everywhere at any time
- Connect to your OpenShelf instance and enjoy the full freedom of your own digital library

## Development Status
- **In Progress**
  - [ ] Implement a WebView-based reading experience for all supported platforms
  - [ ] Enhance the sync and library management capabilities
- **Awaiting upstream patches**
  - [ ] Migrate to [webview_flutter](https://pub.dev/packages/webview_flutter). As a first-party package it is generelly better maintained and more stable than [the current solution](https://pub.dev/packages/flutter_inappwebview), but lacks Windows support at this point in time.
- **Planned**
  - [ ] Exploring the possibilities of custom content rendering directly in Flutter (vs. WebView). This has various potential benefits, but is also an enormous undertaking for the future. Not planned for until v1.0 **at the earliest.**
