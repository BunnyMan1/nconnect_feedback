import 'package:ndash/src/common/device_info/device_info.dart';

/// Contains all relevant feedback information, both user-provided and automatically
/// inferred, that will be eventually sent to the nDash console.
class FeedbackItem {
  const FeedbackItem({
    required this.deviceInfo,
    this.email,
    required this.message,
    required this.type,
    this.user,
    required this.sdkVersion,
    required this.appVersion,
    required this.token,
    required this.userAgent,
    required this.appId,
  });

  final DeviceInfo deviceInfo;
  final String? email;
  final String message;
  final int type;
  final String? user;
  final String? sdkVersion;
  final String? appVersion;
  final String? token;
  final String? userAgent;
  final int? appId;

  FeedbackItem.fromJson(Map<String, dynamic> json)
      : deviceInfo = DeviceInfo.fromJson(json['deviceInfo'] as Map<String, dynamic>),
        email = json['email'] as String?,
        message = json['message'] as String,
        type = json['type'] as int,
        user = json['user'] as String?,
        sdkVersion = json['sdkVersion'] as String?,
        appVersion = json['appVersion'] as String?,
        token = json['token'] as String?,
        appId = json['appId'] as int?,
        userAgent = json['userAgent'] as String?;

  Map<String, dynamic> toJson() {
    return {
      'deviceInfo': deviceInfo.toJson(),
      'email': email,
      'message': message,
      'type': type,
      'user': user,
      'sdkVersion': sdkVersion,
      'appVersion': appVersion,
      'appId': appId,
      'token': token,
      'userAgent': userAgent
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
        'token: $token, '
        'userAgent: $userAgent, '
        'appVersion: $appVersion, '
        '}';
  }
}
