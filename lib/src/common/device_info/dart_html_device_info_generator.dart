// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;
import 'dart:ui' show SingletonFlutterWindow;

import 'package:ndash/src/common/build_info/build_info_manager.dart';
import 'package:ndash/src/common/device_info/device_info.dart';
import 'package:ndash/src/common/device_info/device_info_generator.dart';
import 'package:ndash/src/common/user/user_manager.dart';

class _DartHtmlDeviceInfoGenerator implements DeviceInfoGenerator {
  _DartHtmlDeviceInfoGenerator(
    this.buildInfo,
    this.window,
    this.deviceInfo,
  );

  final BuildInfoManager buildInfo;
  final SingletonFlutterWindow window;
  final AdditionalDeviceInfo deviceInfo;

  @override
  DeviceInfo generate() {
    final base =
        DeviceInfoGenerator.baseDeviceInfo(buildInfo, window, deviceInfo);
    return base.copyWith(
      userAgent: html.window.navigator.userAgent,
    );
  }
}

/// Called by [DeviceInfoGenerator] factory constructor in browsers
DeviceInfoGenerator createDeviceInfoGenerator(BuildInfoManager buildInfo,
    SingletonFlutterWindow window, AdditionalDeviceInfo deviceInfo) {
  return _DartHtmlDeviceInfoGenerator(buildInfo, window, deviceInfo);
}
