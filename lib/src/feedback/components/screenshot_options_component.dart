import 'package:flutter/material.dart';
import 'package:ndash/src/common/theme/ndash_theme.dart';
import 'package:ndash/src/common/utils/email_validator.dart';

class ScreenshotOptionsComponent extends StatefulWidget {
  final int screenShotOptionsValue;
  final Function(int) screenShotOptionsValueChange;

  const ScreenshotOptionsComponent({
    required this.screenShotOptionsValue,
    required this.screenShotOptionsValueChange,
    Key? key,
  }) : super(key: key);

  @override
  _ScreenshotOptionsComponentState createState() => _ScreenshotOptionsComponentState();
}

class _ScreenshotOptionsComponentState extends State<ScreenshotOptionsComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ndashTheme = NdashTheme.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RadioListTile<int>(
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            selected: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            selectedTileColor: ndashTheme.secondaryBackgroundColor,
            value: 1,
            title: Text(
              "Include a Screenshot",
              style: NdashTheme.of(context)!.body1Style.copyWith(fontSize: 16.0),
            ),
            subtitle: Text(
              "Select this option if want to add a screenshot along with your feedback/input.",
              style: NdashTheme.of(context)!.body2Style.copyWith(fontSize: 14.0),
            ),
            groupValue: widget.screenShotOptionsValue,
            onChanged: (v) {
              if (v == null) return;
              widget.screenShotOptionsValueChange(v);
            },
          ),
          SizedBox(height: 28.0),
          RadioListTile<int>(
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            selected: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            selectedTileColor: ndashTheme.secondaryBackgroundColor,
            value: 2,
            title: Text(
              "Continue without Screenshot",
              style: NdashTheme.of(context)!.body1Style.copyWith(fontSize: 16.0),
            ),
            subtitle: Text(
              "Select this option if you don't want to add a screenshot along with your feedback/input.",
              style: NdashTheme.of(context)!.body2Style.copyWith(fontSize: 14.0),
            ),
            groupValue: widget.screenShotOptionsValue,
            onChanged: (v) {
              if (v == null) return;
              widget.screenShotOptionsValueChange(v);
            },
          )
        ],
      ),
    );
  }
}

@visibleForTesting
EmailValidator debugEmailValidator = const EmailValidator();
