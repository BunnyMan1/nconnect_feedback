import 'dart:typed_data';

import 'package:ndash/src/common/network/api.dart';
import 'package:ndash/src/common/utils/error_report.dart';
import 'package:ndash/src/feedback/data/feedback_item.dart';
import 'package:ndash/src/feedback/data/feedback_submitter.dart';

/// Submits feedback immediately to the ndash backend
class DirectFeedbackSubmitter implements FeedbackSubmitter {
  DirectFeedbackSubmitter(NdashApi api) : _api = api;

  final NdashApi _api;

  @override
  Future<void> submit(FeedbackItem item, Uint8List? screenshot) async {
    try {
      await _api.sendFeedback(feedback: item, screenshot: screenshot);
      // ignore: avoid_print
      print("Feedback submitted ✌️ ${item.message}");
    } on UnauthenticatedNdashApiException catch (e, stack) {
      // Project configuration is off, retry at next app start
      reportNdashError(
        e,
        stack,
        'NDash project configuration is wrong, next retry after next app start',
      );
      rethrow;
    } on NdashApiException catch (e, stack) {
      if (e.message != null &&
          e.message!.contains("fails because") &&
          e.message!.contains("is required")) {
        // some required property is missing. The item will never be delivered
        // to the server, therefore discard it.
        reportNdashError(
          e,
          stack,
          'Feedback has missing properties and can not be submitted to server',
        );
        rethrow;
      }
      reportNdashError(
        e,
        stack,
        'NDash server error. Will retry after app restart',
      );
      rethrow;
    }
  }
}
