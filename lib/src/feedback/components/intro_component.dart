import 'package:flutter/material.dart';
import 'package:ndash/src/common/options/ndash_options.dart';
import 'package:ndash/src/common/translation/ndash_localizations.dart';
import 'package:ndash/src/common/widgets/list_tile_button.dart';
import 'package:ndash/src/common/widgets/ndash_icons.dart';
import 'package:ndash/src/feedback/feedback_model.dart';

class IntroComponent extends StatelessWidget {
  final void Function(FeedbackType)? onModeSelectedCallback;

  const IntroComponent(this.onModeSelectedCallback, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final options = NdashOptions.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 16),
      child: Column(
        children: [
          if (options.bugReportButton) ...[
            const SizedBox(height: 12),
            ListTileButton(
              key: const ValueKey('ndash.sdk.intro.report_a_bug_button'),
              icon: NdashIcons.bug,
              iconColor: const Color(0xff9c4db1),
              iconBackgroundColor: const Color(0xffffc4f0),
              title: NdashLocalizations.of(context)!.feedbackModeBugTitle,
              subtitle: NdashLocalizations.of(context)!.feedbackModeBugMsg,
              onPressed: () => onModeSelectedCallback?.call(FeedbackType.bug),
            ),
          ],
          if (options.featureRequestButton) ...[
            const SizedBox(height: 12),
            ListTileButton(
              icon: NdashIcons.feature,
              iconColor: const Color(0xff007cbc),
              iconBackgroundColor: const Color(0xff2bd9fc),
              title: NdashLocalizations.of(context)!.feedbackModeImprovementTitle,
              subtitle: NdashLocalizations.of(context)!.feedbackModeImprovementMsg,
              onPressed: () => onModeSelectedCallback?.call(FeedbackType.improvement),
            ),
          ],
          if (options.praiseButton) ...[
            const SizedBox(height: 12),
            ListTileButton(
              icon: NdashIcons.applause,
              iconColor: const Color(0xff00b779),
              iconBackgroundColor: const Color(0xffcdfbcb),
              title: NdashLocalizations.of(context)!.feedbackModePraiseTitle,
              subtitle: NdashLocalizations.of(context)!.feedbackModePraiseMsg,
              onPressed: () => onModeSelectedCallback?.call(FeedbackType.praise),
            ),
          ],
        ],
      ),
    );
  }
}
