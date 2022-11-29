import 'dart:convert';

import 'package:ndash/src/common/device_info/device_info.dart';
import 'package:ndash/src/version.dart';

/// Contains all relevant feedback information, both user-provided and automatically
/// inferred, that will be eventually sent to the nDash console.
class FeedbackItem {
  const FeedbackItem({
    required this.deviceInfo,
    this.email,
    required this.message,
    required this.type,
    this.user,
    this.sdkVersion = ndashSdkVersion,
    required this.appVersion,
    required this.studentAdmissionNumber,
    required this.token,
    required this.userAgent,
  });

  final DeviceInfo deviceInfo;
  final String? email;
  final String message;
  final int type;
  final String? user;
  final int sdkVersion;
  final String appVersion;
  final String studentAdmissionNumber;
  final String token;
  final String userAgent;

  FeedbackItem.fromJson(Map<String, dynamic> json)
      : deviceInfo = DeviceInfo.fromJson(json['deviceInfo'] as Map<String, dynamic>),
        email = json['email'] as String?,
        message = json['message'] as String,
        type = json['type'] as int,
        user = json['user'] as String?,
        sdkVersion = json['sdkVersion'] as int,
        appVersion = json['appVersion'] as String,
        studentAdmissionNumber = json['studentAdmissionNumber'] as String,
        token = json['token'] as String,
        userAgent = json['userAgent'] as String;

  Map<String, dynamic> toJson() {
    return {
      'deviceInfo': deviceInfo.toJson(),
      'email': email,
      'message': message,
      'type': type,
      'user': user,
      'sdkVersion': sdkVersion,
      'appVersion': appVersion,
      'studentAdmissionNumber': studentAdmissionNumber,
      'token': token,
      'userAgent': userAgent
    };
  }

  /// Encodes the fields for a multipart/form-data request
  Map<String, String?> toMultipartFormFields() {
    return {
      'deviceInfo': json.encode(deviceInfo.toJson()),
      'email': email,
      'message': message,
      'type': type.toString(),
      'user': user,
      'sdkVersion': sdkVersion.toString(),
      'appVersion': appVersion,
      'studentAdmissionNumber': studentAdmissionNumber,
      'userAgent': userAgent,
      'token': token,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedbackItem &&
          runtimeType == other.runtimeType &&
          deviceInfo == other.deviceInfo &&
          email == other.email &&
          message == other.message &&
          type == other.type &&
          user == other.user &&
          sdkVersion == other.sdkVersion &&
          token == other.token &&
          appVersion == other.appVersion &&
          studentAdmissionNumber == other.studentAdmissionNumber &&
          userAgent == other.userAgent;

  @override
  int get hashCode =>
      deviceInfo.hashCode ^
      email.hashCode ^
      message.hashCode ^
      type.hashCode ^
      user.hashCode ^
      sdkVersion.hashCode;

  @override
  String toString() {
    return 'FeedbackItem{'
        'deviceInfo: $deviceInfo, '
        'email: $email, '
        'message: $message, '
        'type: $type, '
        'user: $user, '
        'sdkVersion: $sdkVersion, '
        'studentAdmissionNumber: $studentAdmissionNumber, '
        'token: $token, '
        'userAgent: $userAgent, '
        'appVersion: $appVersion, '
        '}';
  }
}
