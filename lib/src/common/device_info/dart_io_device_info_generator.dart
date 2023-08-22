import 'dart:io';
import 'dart:ui' show SingletonFlutterWindow;

import 'package:ndash/src/common/build_info/build_info_manager.dart';
import 'package:ndash/src/common/device_info/device_info.dart';
import 'package:ndash/src/common/device_info/device_info_generator.dart';
import 'package:ndash/src/common/user/user_manager.dart';

class _DartIoDeviceInfoGenerator implements DeviceInfoGenerator {
  _DartIoDeviceInfoGenerator(
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
      platformOS: Platform.operatingSystem,
      platformOSBuild: Platform.operatingSystemVersion,
      platformVersion: Platform.version,
    );
  }
}

/// Called by [DeviceInfoGenerator] factory constructor
DeviceInfoGenerator createDeviceInfoGenerator(BuildInfoManager buildInfo,
    SingletonFlutterWindow window, AdditionalDeviceInfo deviceInfo) {
  return _DartIoDeviceInfoGenerator(buildInfo, window, deviceInfo);
}
