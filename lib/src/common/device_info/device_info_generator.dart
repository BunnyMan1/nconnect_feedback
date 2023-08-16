import 'package:flutter/foundation.dart';
import 'package:ndash/src/common/build_info/build_info_manager.dart';
import 'package:ndash/src/common/device_info/device_info.dart';
import 'package:ndash/src/common/user/user_manager.dart';

// import a dart:html or dart:io version of `createDeviceInfoGenerator`
// if non are available the stub is used
import 'device_info_generator_stub.dart'
    if (dart.library.html) 'dart_html_device_info_generator.dart'
    if (dart.library.io) 'dart_io_device_info_generator.dart';

abstract class DeviceInfoGenerator {
  /// Loads a [DeviceInfoGenerator] based on the environment by calling the
  /// optional imported createDeviceInfoGenerator function
  factory DeviceInfoGenerator(
    BuildInfoManager buildInfo,
    SingletonFlutterWindow window,
    AdditionalDeviceInfo deviceInfo,
  ) {
    return createDeviceInfoGenerator(buildInfo, window, deviceInfo);
  }

  /// Collection of all [DeviceInfo] shared between all platforms
  static DeviceInfo baseDeviceInfo(
    BuildInfoManager buildInfo,
    SingletonFlutterWindow window,
    AdditionalDeviceInfo deviceInfo,
  ) {
    return DeviceInfo(
      appIsDebug: kDebugMode,
      appVersion: buildInfo.buildVersion,
      buildNumber: buildInfo.buildNumber,
      buildCommit: buildInfo.buildCommit,
      deviceId: buildInfo.deviceId,
      locale: window.locale.toString(),
      padding: [
        window.padding.left,
        window.padding.top,
        window.padding.right,
        window.padding.bottom
      ],
      physicalSize: [window.physicalSize.width, window.physicalSize.height],
      pixelRatio: window.devicePixelRatio,
      textScaleFactor: window.textScaleFactor,
      viewInsets: [
        window.viewInsets.left,
        window.viewInsets.top,
        window.viewInsets.right,
        window.viewInsets.bottom
      ],
      // batteryLevel: deviceInfo.batteryLevel,
      // batteryCapacity: deviceInfo.batteryCapacity,
      // carrierName: deviceInfo.carrierName,
      // networkGeneration: deviceInfo.networkGeneration,
      // deviceModel: deviceInfo.deviceModel,
      // deviceMake: deviceInfo.deviceMake,
    );
  }

  DeviceInfo generate();
}
