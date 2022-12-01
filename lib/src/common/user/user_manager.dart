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
