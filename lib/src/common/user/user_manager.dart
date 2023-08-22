import 'package:battery_info/enums/charging_status.dart';
import 'package:carrier_info/carrier_info.dart';

class UserManager {
  String? userId;
  String? userEmail;
  int? appId;
  String? appVersion;
  String? sdkVersion;
  String? token;
  String? userAgent;

  UserManager({
    this.appId,
    this.appVersion,
    this.token,
    this.userAgent,
    this.userEmail,
    this.userId,
  });
}

class AdditionalDeviceInfo {
  int? batteryLevel;
  int? batteryCapacity;
  String? carrierName;
  String? networkGeneration;
  String? deviceModel;
  String? deviceMake;
  String? technology;
  int? currentNow;
  int? currentAverage;
  int? chargeTimeRemaining;
  String? health;
  String? pluggedStatus;
  int? remainingEnergy;
  int? scale;
  int? temperature;
  int? voltage;
  bool? present;
  ChargingStatus? chargingStatus;
  String? networkCountryIso;
  String? mobileCountryCode;
  String? mobileNetworkCode;
  String? displayName;
  String? simState;
  String? isoCountryCode;
  CellId? cellId;
  String? phoneNumber;
  int? subscriptionId;
  String? radioType;
  String? networkOperatorName;
  bool? carrierAllowsVOIP;

  AdditionalDeviceInfo({
    this.batteryLevel,
    this.batteryCapacity,
    this.carrierName,
    this.networkGeneration,
    this.deviceModel,
    this.deviceMake,
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
    this.networkCountryIso,
    this.mobileCountryCode,
    this.mobileNetworkCode,
    this.displayName,
    this.simState,
    this.isoCountryCode,
    this.cellId,
    this.phoneNumber,
    this.subscriptionId,
    this.radioType,
    this.networkOperatorName,
    this.carrierAllowsVOIP,
  });

  Map<String, dynamic> toJson() {
    return {
      'battery_level': batteryLevel,
      'battery_capacity': batteryCapacity,
      'network_generation': networkGeneration,
      'carrier_name': carrierName,
      'device_model': deviceModel,
      'device_make': deviceMake,
      'technology': technology,
      'current_now': currentNow,
      'current_average': currentAverage,
      'charge_time_remaining': chargeTimeRemaining,
      'health': health,
      'plugged_status': pluggedStatus,
      'remaining_energy': remainingEnergy,
      'scale': scale,
      'temperature': temperature,
      'voltage': voltage,
      'network_country_iso': networkCountryIso,
      'mobile_country_code': mobileCountryCode,
      'mobile_network_code': mobileNetworkCode,
      'display_name': displayName,
      'sim_state': simState,
      'iso_country_code': isoCountryCode,
      'phone_number': phoneNumber,
      'subscription_id': subscriptionId,
      'radio_type': radioType,
      'network_operator_name': networkOperatorName,
      'present': present,
      'carrier_allows_voip': carrierAllowsVOIP,
      'charging_status': chargingStatus.toString().split('.').last,
      'cell_id': cellId?.cid,
    };
  }
}
