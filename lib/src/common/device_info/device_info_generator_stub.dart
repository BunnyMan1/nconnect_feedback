import 'dart:ui' show SingletonFlutterWindow;

import 'package:ndash/src/common/build_info/build_info_manager.dart';
import 'package:ndash/src/common/device_info/device_info_generator.dart';

DeviceInfoGenerator createDeviceInfoGenerator(
  BuildInfoManager buildInfo,
  SingletonFlutterWindow window,
) {
  throw UnsupportedError(
    'Cannot create a Device Info Generator without dart:html or dart:io',
  );
}
