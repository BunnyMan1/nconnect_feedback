import 'package:flutter/material.dart';
import 'package:ndash/src/common/translation/ndash_localizations.dart';
import 'package:ndash/src/common/widgets/list_tile_button.dart';
import 'package:ndash/src/common/widgets/ndash_icons.dart';

/// Feedback was successfully submitted -> close
class SuccessComponent extends StatelessWidget {
  final VoidCallback? onClosedCallback;

  const SuccessComponent(
    this.onClosedCallback, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          ListTileButton(
            key: const ValueKey('ndash.sdk.exit_button'),
            icon: NdashIcons.exit,
            iconColor: const Color(0xff9c4db1),
            iconBackgroundColor: const Color(0xffffc4f0),
            title: NdashLocalizations.of(context)!.feedbackStateSuccessCloseTitle,
            subtitle: NdashLocalizations.of(context)!.feedbackStateSuccessCloseMsg,
            onPressed: () => onClosedCallback?.call(),
          ),
        ],
      ),
    );
  }
}
