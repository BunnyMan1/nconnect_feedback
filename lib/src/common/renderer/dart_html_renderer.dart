import 'dart:js' as js;

import 'package:ndash/src/common/renderer/renderer.dart';

Renderer getRenderer() {
  return isCanvasKitRenderer ? Renderer.canvasKit : Renderer.html;
}

bool get isCanvasKitRenderer {
  final flutterCanvasKit = js.context['flutterCanvasKit'];
  return flutterCanvasKit != null;
}
