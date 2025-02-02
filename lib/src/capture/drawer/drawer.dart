import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ndash/src/capture/capture_provider.dart';
import 'package:ndash/src/capture/drawer/color_picker.dart';
import 'package:ndash/src/capture/drawer/pen.dart';
import 'package:ndash/src/common/theme/ndash_theme.dart';
import 'package:ndash/src/common/translation/ndash_localizations.dart';
import 'package:ndash/src/common/widgets/ndash_icons.dart';

// ignore: use_key_in_widget_constructors
class Drawer extends StatelessWidget {
  static const width = 80.0;

  @override
  Widget build(BuildContext context) {
    final controller = context.sketcherController!;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, __) {
        return SizedBox(
          width: Drawer.width,
          child: Stack(
            children: <Widget>[
              
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 80),
                      UndoButton(onTap: controller.undoGesture),
                      ColorPicker(
                        selectedColor: controller.color,
                        onChanged: (newColor) {
                          controller.color = newColor;
                        },
                      ),
                      FeedbackPen(color: controller.color),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class UndoButton extends StatelessWidget {
  const UndoButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: NdashLocalizations.of(context)!.undoButtonLabel,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Icon(
            NdashIcons.undo,
            color: NdashTheme.of(context)!.dividerColor,
          ),
        ),
      ),
    );
  }
}
