import 'dart:typed_data';

import 'package:ndash/src/feedback/data/direct_feedback_submitter.dart';
import 'package:ndash/src/feedback/data/feedback_item.dart';
import 'package:ndash/src/feedback/data/retrying_feedback_submitter.dart';

/// Interface which allows submission of feedback to the backend
///
/// Known subtypes
/// - [RetryingFeedbackSubmitter]
/// - [DirectFeedbackSubmitter]
abstract class FeedbackSubmitter {
  /// Submits the feedback item to the backend
  Future<void> submit(FeedbackItem item, Uint8List? screenshot, String mediaUrl,String feedbackSubmitUrl);
}
