import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/enums/charging_status.dart';
import 'package:carrier_info/carrier_info.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:ndash/src/common/user/user_manager.dart';
import 'package:ndash/src/feedback/data/feedback_item.dart';
import 'package:path_provider/path_provider.dart';

/// API client to communicate with the nDash servers
class NdashApi {
  String? getCSV(List<double>? list) {
    if (list == null || list.length == 0) return null;
    String csv = "";
    for (var i in list) csv += i.toString() + ',';
    if (csv[csv.length - 1] == ",") csv = csv.substring(0, csv.length - 1);
    return csv;
  }

  /// Reports a feedback
  ///
  /// POST /feedback
  ///
  /// When [screenshot] is provided it sends a multipart request
  Future<void> sendFeedback({
    required FeedbackItem feedback,
    Uint8List? screenshot,
    required String mediaUrl,
    required String feedbackSumbitUrl,
  }) async {
    //TODO: hardcoding the media url, change these to 2 urls and use one after other !
    // final String mediaUrl = 'http://172.40.42.57:5000/api/common/v1/media';
    // final String feedbackSumbitUrl = "http://172.40.42.57:5000/api/common/v1/feedback";
    Dio dio = Dio();

    dio.options.headers["Content-Type"] = "multipart/form-data";
    dio.options.headers['authorization'] = 'Bearer ${feedback.token}';

    Response? response;
    try {
      if (screenshot != null) {
        File file = File.fromRawPath(screenshot);
        final tempDir = await getTemporaryDirectory();
        file = await File('${tempDir.path}/image.png').create();
        file.writeAsBytesSync(screenshot);
        response = await dio.post(
          mediaUrl,
          data: FormData.fromMap({
            'Files': await MultipartFile.fromFile(
              file.path,
            )
          }),
        );
      }

      var additionalDeviceInfo = await loadAdditionalDeviceInfo();

      // success 🎉'
      Dio dio2 = Dio();
      dio2.options.headers['authorization'] = 'Bearer ${feedback.token}';
      print("${screenshot}...........");
      var data = {
        "email": feedback.email,
        "message": feedback.message,
        "type": feedback.type,
        "sdk_version": feedback.sdkVersion.toString(),
        "app_version": feedback.appVersion,
        "auth_token": feedback.token,
        "user_agent": feedback.userAgent,
        "application_id": feedback.appId,
        "application_platform_id": Platform.isIOS ? 3 : 2,
        "device_id": feedback.deviceInfo.deviceId,
        "padding": getCSV(feedback.deviceInfo.padding),
        "physical_size": getCSV(feedback.deviceInfo.physicalSize),
        "platform_version": feedback.deviceInfo.platformVersion,
        "additional_device_info": additionalDeviceInfo.toJson(),
        "attachments": response != null
            ? [
                {
                  "id": response.data[0]['id'],
                  "display_order": response.data[0]['display_order'],
                  "display_label": response.data[0]['display_label'],
                  "description": response.data[0]['description'],
                  "is_primary": response.data[0]['is_primary']
                }
              ]
            : null
      };
      response = await dio2.post(feedbackSumbitUrl, data: data);
      if (response.statusCode == 201) {
        return;
      }
      if (response.statusCode == 401) {
        throw UnauthenticatedNdashApiException(response);
      }

      throw NdashApiException(response: response);
    } catch (e) {
      print(" error : $e");
      if (e is DioException) {
        print("url : ${e.requestOptions.uri}");
        print("params : ${e.requestOptions.queryParameters}");
        print("data: ${e.requestOptions.data}");
        print("resp : ${e.response?.data}");
      }
    }
  }

  // Load Additional Device Info.
  Future<AdditionalDeviceInfo> loadAdditionalDeviceInfo() async {
    int? batteryLevel,
        batteryCapacity,
        currentNow,
        currentAverage,
        chargeTimeRemaining,
        remainingEnergy,
        scale,
        temperature,
        voltage,
        subscriptionId;

    String? carrierName,
        networkGeneration,
        deviceModel,
        deviceMake,
        health,
        technology,
        pluggedStatus,
        networkCountryIso,
        mobileCountryCode,
        mobileNetworkCode,
        displayName,
        simState,
        isoCountryCode,
        phoneNumber,
        radioType,
        networkOperatorName;

    bool? present, carrierAllowsVOIP;

    ChargingStatus? chargingStatus;

    CellId? cellId;

    if (Platform.isAndroid) {
      var batteryInfo = await BatteryInfoPlugin().androidBatteryInfo;
      batteryLevel = batteryInfo?.batteryLevel;
      batteryCapacity = batteryInfo?.batteryCapacity;
      chargeTimeRemaining = batteryInfo?.chargeTimeRemaining;
      currentNow = batteryInfo?.currentNow;
      currentAverage = batteryInfo?.currentAverage;
      remainingEnergy = batteryInfo?.remainingEnergy;
      scale = batteryInfo?.scale;
      voltage = batteryInfo?.voltage;
      health = batteryInfo?.health;
      pluggedStatus = batteryInfo?.pluggedStatus;
      present = batteryInfo?.present;
      chargingStatus = batteryInfo?.chargingStatus;
      chargeTimeRemaining = batteryInfo?.chargeTimeRemaining;
      technology = batteryInfo?.technology;

      var deviceManufacturDetails = await DeviceInfoPlugin().androidInfo;
      deviceModel = deviceManufacturDetails.model;
      deviceMake = deviceManufacturDetails.manufacturer;
    } else if (Platform.isIOS) {
      var batteryInfo = await BatteryInfoPlugin().iosBatteryInfo;
      batteryLevel = batteryInfo?.batteryLevel;
      chargingStatus = batteryInfo?.chargingStatus;

      var deviceManufacturDetails = await DeviceInfoPlugin().iosInfo;
      deviceModel = deviceManufacturDetails.model;
      deviceMake = deviceManufacturDetails.utsname.machine;
    }

    try {
      if (Platform.isAndroid) {
        var carrierInfo = (await CarrierInfo.getAndroidInfo())?.telephonyInfo.first;
        carrierName = carrierInfo?.carrierName;
        networkGeneration = carrierInfo?.networkGeneration;
        networkCountryIso = carrierInfo?.networkCountryIso;
        mobileCountryCode = carrierInfo?.mobileCountryCode;
        displayName = carrierInfo?.displayName;
        simState = carrierInfo?.simState;
        isoCountryCode = carrierInfo?.isoCountryCode;
        phoneNumber = carrierInfo?.phoneNumber;
        radioType = carrierInfo?.radioType;
        networkOperatorName = carrierInfo?.networkOperatorName;
        subscriptionId = carrierInfo?.subscriptionId;
        cellId = carrierInfo?.cellId;
      } else if (Platform.isIOS) {
        var carrierInfo = (await CarrierInfo.getIosInfo()).carrierData.first;
        carrierName = carrierInfo.carrierName;
        networkGeneration = carrierInfo.mobileNetworkCode;
        mobileNetworkCode = carrierInfo.mobileNetworkCode;
        mobileCountryCode = carrierInfo.mobileCountryCode;
        isoCountryCode = carrierInfo.isoCountryCode;
        carrierAllowsVOIP = carrierInfo.carrierAllowsVOIP;
      }
    } catch (e) {}

    var additionalDeviceInfo = AdditionalDeviceInfo(
      batteryLevel: batteryLevel,
      batteryCapacity: batteryCapacity,
      carrierName: carrierName,
      networkGeneration: networkGeneration,
      deviceModel: deviceModel,
      deviceMake: deviceMake,
      chargeTimeRemaining: chargeTimeRemaining,
      chargingStatus: chargingStatus,
      currentAverage: currentAverage,
      currentNow: currentNow,
      health: health,
      pluggedStatus: pluggedStatus,
      present: present,
      remainingEnergy: remainingEnergy,
      scale: scale,
      technology: technology,
      temperature: temperature,
      voltage: voltage,
      networkCountryIso: networkCountryIso,
      mobileCountryCode: mobileCountryCode,
      mobileNetworkCode: mobileNetworkCode,
      displayName: displayName,
      simState: simState,
      isoCountryCode: isoCountryCode,
      cellId: cellId,
      phoneNumber: phoneNumber,
      subscriptionId: subscriptionId,
      radioType: radioType,
      networkOperatorName: networkOperatorName,
      carrierAllowsVOIP: carrierAllowsVOIP,
    );

    return additionalDeviceInfo;
  }
}

/// Generic error from the nDash API
class NdashApiException implements Exception {
  NdashApiException({String? message, this.response}) : _message = message;
  String? get message {
    final String? bodyMessage = () {
      try {
        final json = jsonDecode(response?.data ?? "") as Map?;
        return json?['message'] as String?;
      } catch (e) {
        return response?.data;
      }
    }();
    if (_message == null) {
      return bodyMessage;
    }
    return "$_message $bodyMessage";
  }

  final String? _message;
  final Response? response;

  @override
  String toString() {
    return 'NdashApiException{${response?.statusCode}, message: $message, body: ${response?.data}';
  }
}

/// Thrown when the server couldn't match the project + secret to a existing project
class UnauthenticatedNdashApiException extends NdashApiException {
  UnauthenticatedNdashApiException(
    Response response,
  ) : super(
          message: "Request made is unauthenticated. Please check the parameters being used.",
          response: response,
        );
  @override
  String toString() {
    return 'UnauthenticatedNdashApiException{$message, status code: ${response?.statusCode}';
  }
}
