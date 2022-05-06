import 'package:flutter/widgets.dart';
import 'package:ndash/src/common/user/user_manager.dart';
import 'package:ndash/src/feedback/feedback_model.dart';

class NdashProvider extends InheritedWidget {
  const NdashProvider({
    Key? key,
    required this.userManager,
    required this.feedbackModel,
    required Widget child,
  }) : super(key: key, child: child);

  final UserManager userManager;
  final FeedbackModel feedbackModel;

  static NdashProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NdashProvider>();
  }

  @override
  bool updateShouldNotify(NdashProvider old) {
    return feedbackModel != old.feedbackModel || userManager != old.userManager;
  }
}

extension NdashExtensions on BuildContext {
  FeedbackModel? get feedbackModel => NdashProvider.of(this)?.feedbackModel;

  UserManager? get userManager => NdashProvider.of(this)?.userManager;
}
