import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:ndash/src/common/renderer/renderer.dart';

Renderer getRenderer() {
  return isCanvasKitRenderer ? Renderer.canvasKit : Renderer.html;
}

bool get isCanvasKitRenderer {
  final flutterCanvasKit =
      globalContext.getProperty<JSAny?>('flutterCanvasKit'.toJS);
  return flutterCanvasKit != null &&
      !flutterCanvasKit.isUndefined &&
      !flutterCanvasKit.isNull;
}
