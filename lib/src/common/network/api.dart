import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
// import 'package:http/http.dart';

import 'package:ndash/src/feedback/data/feedback_item.dart';
import 'package:path_provider/path_provider.dart';

/// API client to communicate with the nDash servers
class NdashApi {
  NdashApi({
    // required Client httpClient,
    required String projectId,
    required String secret,
  })  :
        //  _httpClient = httpClient,
        _projectId = projectId,
        _secret = secret;

  // final Client _httpClient;
  final String _projectId;
  final String _secret;

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
  }) async {
    // final uri = Uri.parse('$_host/feedback');
    //TODO: hardcoding the media url, change these to 2 urls and use one after other !

    // final uri = Uri.parse("http://10.11.13.114:5000/api/common/v1/media");
    // print(" the model : ${feedback.toJson()}");
    final arguments = feedback.toMultipartFormFields()
      ..removeWhere((key, value) => value == null || value.isEmpty);
    final argumentsNN = arguments.map((key, value) => MapEntry(key, value!));

    // final BaseRequest request = () {
    //   if (screenshot != null) {
    //     return MultipartRequest('POST', uri)
    //       // ..fields.addAll(argumentsNN)
    //       ..files.add(
    //         MultipartFile.fromBytes(
    //           'file',
    //           screenshot,
    //           filename: 'file.png',
    //           contentType: MediaType('image', 'png'),
    //         ),
    //       );
    //   }
    //   return Request('POST', uri)..bodyFields = argumentsNN;
    // }();

    Dio dio = Dio();

    dio.options.headers["Content-Type"] = "multipart/form-data";
    dio.options.headers['authorization'] = 'Bearer ${feedback.token}';
    // print(" screen: $screenshot");
    if (screenshot != null) {
      Response? response;
      try {
        // File file = File.fromRawPath(screenshot);
        final tempDir = await getTemporaryDirectory();
        File file = await File('${tempDir.path}/image.png').create();
        file.writeAsBytesSync(screenshot);
        response = await dio.post(
          'http://172.40.42.57:5000/api/common/v1/media',
          data: FormData.fromMap({
            'Files': await MultipartFile.fromFile(
              file.path,
              // contentType: MediaType('image', 'png'),
            )
          }),
        );
        print("media upload data  ====> ${response.data}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          // success 🎉'
          print(" success 🎉 after media upload");
          Dio dio2 = Dio();
          dio2.options.headers['authorization'] = 'Bearer ${feedback.token}';

          var data = {
            "email": feedback.email,
            "message": feedback.message,
            "type": feedback.type,
            "sdk_version": feedback.sdkVersion.toString(),
            "app_version": feedback.appVersion,
            "auth_token": feedback.token,
            "user_agent": feedback.userAgent,
            //TODO: get app id from params.
            "application_id": 3,
            "application_platform_id": Platform.isIOS ? 3 : 2,
            "device_id": feedback.deviceInfo.deviceId,
            "padding": getCSV(feedback.deviceInfo.padding),
            "physical_size": getCSV(feedback.deviceInfo.physicalSize),
            "attachments": [
              {
                "id": response.data[0]['id'],
                "display_order": response.data[0]['display_order'],
                "display_label": response.data[0]['display_label'],
                "description": response.data[0]['description'],
                "is_primary": response.data[0]['is_primary']
              }
            ]
          };
          print(" data is =====> $data");
          response =
              await dio2.post('http://172.40.42.57:5000/api/common/v1/feedback', data: data);
          print("feedback create response data  ====> ${response.data}");
          if (response.statusCode == 201) {
            print("success again 🎉");
            return;
          }
          if (response.statusCode == 401) {
            throw UnauthenticatedNdashApiException(response, _projectId, _secret);
          }

          throw NdashApiException(response: response);
        }
        if (response.statusCode == 401) {
          throw UnauthenticatedNdashApiException(response, _projectId, _secret);
        }

        throw NdashApiException(response: response);
      } catch (e) {
        print(" error : $e");

        if (e is DioError) {
          print("url : ${e.requestOptions.uri}");
          print("params : ${e.requestOptions.queryParameters}");
          print("data: ${e.requestOptions.data}");
          print("resp : ${e.response?.data}");
        }
      }
    }

    // print("  --> the request that is being sent to server : ${request.toString()}");
    log("$argumentsNN");
    // final response = await _send(request, feedback.token);
    // print(" ===> response : ${response.body}");
    // if (response.statusCode == 200 || response.statusCode == 200) {
    //   // success 🎉'
    //   print(" success 🎉");
    //   return;
    // }
    // if (response.statusCode == 401) {
    //   throw UnauthenticatedNdashApiException(response, _projectId, _secret);
    // }
    // throw NdashApiException(response: response);
  }

  /// Sends a [BaseRequest] after attaching HTTP headers
  // Future<Response> _send(BaseRequest request, String token) async {
  //   // request.headers['project'] = 'Project $_projectId';
  //   request.headers['authorization'] = 'Bearer $token';

  //   final streamedResponse = await _httpClient.send(request);
  //   return Response.fromStream(streamedResponse);
  // }
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
    this.projectId,
    this.secret,
  ) : super(
          message: "Unknown projectId:'$projectId' or invalid secret:'$secret'",
          response: response,
        );

  final String projectId;
  final String secret;

  @override
  String toString() {
    return 'UnauthenticatedNdashApiException{$message, status code: ${response?.statusCode}';
  }
}
