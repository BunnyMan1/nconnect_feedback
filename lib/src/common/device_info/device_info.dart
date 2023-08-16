import 'package:battery_info/enums/charging_status.dart';
import 'package:flutter/foundation.dart';

class DeviceInfo {
  final bool? appIsDebug;
  final String? appVersion;
  final String? buildNumber;
  final String? buildCommit;
  final String? deviceId;
  final String? locale;
  final List<double>? padding;
  final List<double>? physicalSize;
  final double? pixelRatio;
  final int? currentNow;
  final int? currentAverage;
  final int? chargeTimeRemaining;
  final String? health;
  final String? pluggedStatus;
  final String? technology;
  final int? batteryLevel;
  final int? batteryCapacity;
  final int? remainingEnergy;
  final int? scale;
  final int? temperature;
  final int? voltage;
  final bool? present;
  final ChargingStatus? chargingStatus;

  /// Carrier name of the sim
  final String? carrierName;

  /// The mobile network radioType: 5G, 4G ... 2G
  final String? networkGeneration;
  final String? deviceModel;
  final String? deviceMake;

  /// A string representing the operating system or platform.
  ///
  /// Platform.operatingSystem
  final String? platformOS;

  /// A string representing the version of the operating system or platform.
  ///
  /// Platform.operatingSystemVersion
  final String? platformOSBuild;

  /// The version of the current Dart runtime.
  ///
  /// Platform.version
  final String? platformVersion;

  final double? textScaleFactor;
  final List<double>? viewInsets;

  /// When in web, the full user agent String of the browser
  ///
  /// https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/User-Agent
  final String? userAgent;

  const DeviceInfo({
    this.appIsDebug,
    this.appVersion,
    this.buildNumber,
    this.buildCommit,
    this.deviceId,
    this.locale,
    this.padding = const [],
    this.physicalSize = const [],
    this.pixelRatio,
    this.platformOS,
    this.platformOSBuild,
    this.platformVersion,
    this.textScaleFactor,
    this.viewInsets = const [],
    this.userAgent,
    this.batteryCapacity,
    this.batteryLevel,
    this.chargeTimeRemaining,
    this.chargingStatus,
    this.currentAverage,
    this.currentNow,
    this.health,
    this.pluggedStatus,
    this.present,
    this.remainingEnergy,
    this.scale,
    this.technology,
    this.temperature,
    this.voltage,
    this.carrierName,
    this.networkGeneration,
    this.deviceMake,
    this.deviceModel,
  });

  DeviceInfo copyWith({
    bool? appIsDebug,
    String? appVersion,
    String? buildNumber,
    String? buildCommit,
    String? deviceId,
    String? locale,
    List<double>? padding,
    List<double>? physicalSize,
    double? pixelRatio,
    String? platformOS,
    String? platformOSBuild,
    String? platformVersion,
    double? textScaleFactor,
    List<double>? viewInsets,
    String? userAgent,
    int? currentNow,
    int? currentAverage,
    int? chargeTimeRemaining,
    String? health,
    String? pluggedStatus,
    String? technology,
    int? batteryLevel,
    int? batteryCapacity,
    int? remainingEnergy,
    int? scale,
    int? temperature,
    int? voltage,
    bool? present,
    ChargingStatus? chargingStatus,
    String? carrierName,
    String? networkGeneration,
    String? deviceModel,
    String? deviceMake,
  }) {
    return DeviceInfo(
      appIsDebug: appIsDebug ?? this.appIsDebug,
      appVersion: appVersion ?? this.appVersion,
      buildNumber: buildNumber ?? this.buildNumber,
      buildCommit: buildCommit ?? this.buildCommit,
      deviceId: deviceId ?? this.deviceId,
      locale: locale ?? this.locale,
      padding: padding ?? this.padding,
      physicalSize: physicalSize ?? this.physicalSize,
      pixelRatio: pixelRatio ?? this.pixelRatio,
      platformOS: platformOS ?? this.platformOS,
      platformOSBuild: platformOSBuild ?? this.platformOSBuild,
      platformVersion: platformVersion ?? this.platformVersion,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      viewInsets: viewInsets ?? this.viewInsets,
      userAgent: userAgent ?? this.userAgent,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      batteryCapacity: batteryCapacity ?? this.batteryCapacity,
      carrierName: carrierName ?? this.carrierName,
      networkGeneration: networkGeneration ?? this.networkGeneration,
      deviceModel: deviceModel ?? this.deviceModel,
      deviceMake: deviceMake ?? this.deviceMake,
      chargeTimeRemaining: chargeTimeRemaining ?? this.chargeTimeRemaining,
      chargingStatus: chargingStatus ?? this.chargingStatus,
      currentAverage: currentAverage ?? this.currentAverage,
      currentNow: currentNow ?? this.currentNow,
      health: health ?? this.health,
      pluggedStatus: pluggedStatus ?? this.pluggedStatus,
      present: present ?? this.present,
      remainingEnergy: remainingEnergy ?? this.remainingEnergy,
      scale: scale ?? this.scale,
      technology: technology ?? this.technology,
      temperature: temperature ?? this.temperature,
      voltage: voltage ?? this.voltage,
    );
  }

  @override
  String toString() {
    return 'DeviceInfo{'
        'appIsDebug: $appIsDebug, '
        'appVersion: $appVersion, '
        'buildNumber: $buildNumber, '
        'buildCommit: $buildCommit, '
        'deviceId: $deviceId, '
        'locale: $locale, '
        'padding: $padding, '
        'physicalSize: $physicalSize, '
        'pixelRatio: $pixelRatio, '
        'platformOS: $platformOS, '
        'platformOSBuild: $platformOSBuild, '
        'platformVersion: $platformVersion, '
        'textScaleFactor: $textScaleFactor, '
        'viewInsets: $viewInsets, '
        'userAgent: $userAgent, '
        'batteryLevel: $batteryLevel, '
        'batteryCapacity: $batteryCapacity, '
        'carrierName: $carrierName, '
        'networkGeneration: $networkGeneration, '
        'deviceModel: $deviceModel, '
        'deviceMake: $deviceMake, '
        'chargeTimeRemaining : $chargeTimeRemaining, '
        'chargingStatus : $chargingStatus, '
        'currentAverage : $currentAverage, '
        'currentNow : $currentNow, '
        'health : $health, '
        'pluggedStatus : $pluggedStatus, '
        'present : $present, '
        'scale : $scale, '
        'technology : $technology, '
        'temperature : $temperature, '
        'voltage : $voltage, '
        '}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceInfo &&
          runtimeType == other.runtimeType &&
          appIsDebug == other.appIsDebug &&
          appVersion == other.appVersion &&
          buildNumber == other.buildNumber &&
          buildCommit == other.buildCommit &&
          deviceId == other.deviceId &&
          locale == other.locale &&
          listEquals(padding, other.padding) &&
          listEquals(physicalSize, other.physicalSize) &&
          pixelRatio == other.pixelRatio &&
          platformOS == other.platformOS &&
          platformOSBuild == other.platformOSBuild &&
          platformVersion == other.platformVersion &&
          textScaleFactor == other.textScaleFactor &&
          listEquals(viewInsets, other.viewInsets) &&
          userAgent == other.userAgent &&
          batteryLevel == other.batteryLevel &&
          batteryCapacity == other.batteryCapacity &&
          chargeTimeRemaining == other.chargeTimeRemaining &&
          chargingStatus == other.chargingStatus &&
          currentAverage == other.currentAverage &&
          currentNow == other.currentNow &&
          health == other.health &&
          pluggedStatus == other.pluggedStatus &&
          present == other.present &&
          remainingEnergy == other.remainingEnergy &&
          scale == other.scale &&
          technology == other.technology &&
          temperature == other.temperature &&
          voltage == other.voltage &&
          carrierName == other.carrierName &&
          networkGeneration == other.networkGeneration &&
          deviceModel == other.deviceModel &&
          deviceMake == other.deviceMake);

  @override
  int get hashCode =>
      appIsDebug.hashCode ^
      appVersion.hashCode ^
      buildNumber.hashCode ^
      buildCommit.hashCode ^
      deviceId.hashCode ^
      locale.hashCode ^
      padding.hashCode ^
      physicalSize.hashCode ^
      pixelRatio.hashCode ^
      platformOS.hashCode ^
      platformOSBuild.hashCode ^
      platformVersion.hashCode ^
      textScaleFactor.hashCode ^
      viewInsets.hashCode ^
      userAgent.hashCode ^
      batteryLevel.hashCode ^
      batteryCapacity.hashCode ^
      chargeTimeRemaining.hashCode ^
      chargingStatus.hashCode ^
      currentAverage.hashCode ^
      currentNow.hashCode ^
      health.hashCode ^
      pluggedStatus.hashCode ^
      present.hashCode ^
      remainingEnergy.hashCode ^
      scale.hashCode ^
      technology.hashCode ^
      temperature.hashCode ^
      voltage.hashCode ^
      carrierName.hashCode ^
      networkGeneration.hashCode ^
      deviceModel.hashCode ^
      deviceMake.hashCode;

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      appIsDebug: json['appIsDebug'] as bool?,
      appVersion: json['appVersion'] as String?,
      buildNumber: json['buildNumber'] as String?,
      buildCommit: json['buildCommit'] as String?,
      deviceId: json['deviceId'] as String?,
      locale: json['locale'] as String?,
      padding: (json['padding'] as List<dynamic>?)
              ?.cast<num>()
              .map((i) => i.toDouble())
              .toList(growable: false) ??
          [],
      physicalSize: (json['physicalSize'] as List<dynamic>?)
              ?.cast<num>()
              .map((i) => i.toDouble())
              .toList(growable: false) ??
          [],
      pixelRatio: (json['pixelRatio'] as num?)?.toDouble(),
      platformOS: json['platformOS'] as String?,
      platformOSBuild: json['platformOSBuild'] as String?,
      platformVersion: json['platformVersion'] as String?,
      textScaleFactor: (json['textScaleFactor'] as num?)?.toDouble(),
      viewInsets: (json['viewInsets'] as List<dynamic>?)
              ?.cast<num>()
              .map((i) => i.toDouble())
              .toList(growable: false) ??
          [],
      userAgent: json['userAgent'] as String?,
      batteryLevel: json['batteryLevel'] as int?,
      batteryCapacity: json['batteryCapacity'] as int?,
      carrierName: json['carrierName'] as String?,
      networkGeneration: json['networkGeneration'] as String?,
      deviceModel: json['networkGeneration'] as String?,
      deviceMake: json['networkGeneration'] as String?,
      currentNow: json['currentNow'] as int?,
      currentAverage: json['currentAverage'] as int?,
      chargeTimeRemaining: json['chargeTimeRemaining'] as int?,
      health: json['health'] as String?,
      pluggedStatus: json['pluggedStatus'] as String?,
      technology: json['technology'] as String?,
      remainingEnergy: json['remainingEnergy'] as int?,
      scale: json['scale'] as int?,
      temperature: json['temperature'] as int?,
      voltage: json['voltage'] as int?,
      present: json['present'] as bool?,
      chargingStatus: json['chargingStatus'] as ChargingStatus?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> uiValues = {};

    if (appIsDebug != null) {
      uiValues['appIsDebug'] = appIsDebug;
    }

    if (appVersion != null) {
      uiValues['appVersion'] = appVersion;
    }

    if (buildNumber != null) {
      uiValues['buildNumber'] = buildNumber;
    }

    if (buildCommit != null) {
      uiValues['buildCommit'] = buildCommit;
    }
    if (deviceId != null) {
      uiValues['deviceId'] = deviceId;
    }

    if (locale != null) {
      uiValues['locale'] = locale.toString();
    }

    if (padding != null && padding!.isNotEmpty) {
      uiValues['padding'] = padding;
    }

    if (physicalSize != null && physicalSize!.isNotEmpty) {
      uiValues['physicalSize'] = physicalSize;
    }

    if (pixelRatio != null) {
      uiValues['pixelRatio'] = pixelRatio;
    }

    if (platformOS != null) {
      uiValues['platformOS'] = platformOS;
    }

    if (platformOSBuild != null) {
      uiValues['platformOSBuild'] = platformOSBuild;
    }

    if (platformVersion != null) {
      uiValues['platformVersion'] = platformVersion;
    }

    if (textScaleFactor != null) {
      uiValues['textScaleFactor'] = textScaleFactor;
    }

    if (viewInsets != null && viewInsets!.isNotEmpty) {
      uiValues['viewInsets'] = viewInsets;
    }

    if (userAgent != null) {
      uiValues['userAgent'] = userAgent;
    }

    if (batteryLevel != null) {
      uiValues['batteryLevel'] = batteryLevel;
    }

    if (batteryCapacity != null) {
      uiValues['batteryCapacity'] = batteryCapacity;
    }

    if (carrierName != null) {
      uiValues['carrierName'] = carrierName;
    }

    if (networkGeneration != null) {
      uiValues['networkGeneration'] = networkGeneration;
    }

    if (deviceModel != null) {
      uiValues['deviceModel'] = deviceModel;
    }

    if (deviceMake != null) {
      uiValues['deviceMake'] = deviceMake;
    }

    if (chargeTimeRemaining != null) {
      uiValues['chargeTimeRemaining'] = chargeTimeRemaining;
    }

    if (chargingStatus != null) {
      uiValues['chargingStatus'] = chargingStatus;
    }

    if (currentAverage != null) {
      uiValues['currentAverage'] = currentAverage;
    }

    if (currentNow != null) {
      uiValues['currentNow'] = currentNow;
    }

    if (health != null) {
      uiValues['health'] = health;
    }

    if (pluggedStatus != null) {
      uiValues['pluggedStatus'] = pluggedStatus;
    }

    if (present != null) {
      uiValues['present'] = present;
    }

    if (remainingEnergy != null) {
      uiValues['remainingEnergy'] = remainingEnergy;
    }

    if (scale != null) {
      uiValues['scale'] = scale;
    }

    if (technology != null) {
      uiValues['technology'] = technology;
    }

    if (temperature != null) {
      uiValues['temperature'] = temperature;
    }

    if (voltage != null) {
      uiValues['voltage'] = voltage;
    }

    return uiValues;
  }
}
