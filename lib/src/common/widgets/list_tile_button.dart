import 'package:flutter/material.dart';
import 'package:ndash/src/common/theme/ndash_theme.dart';
import 'package:ndash/src/common/theme/ndash_theme_data.dart';

class ListTileButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final VoidCallback onPressed;

  const ListTileButton({
    Key? key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.iconColor = NdashThemeData.white,
    this.iconBackgroundColor = NdashThemeData.black,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: Material(
        elevation: 0.0,
        color: NdashTheme.of(context)!.primaryBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                if (icon != null)
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: iconBackgroundColor,
                    ),
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Icon(
                      icon,
                      size: 22,
                      color: iconColor,
                    ),
                  ),
                if (icon != null) const SizedBox(width: 16),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: NdashTheme.of(context)!.body1Style.copyWith(fontSize: 16.0),
                      ),
                      Text(
                        subtitle,
                        style: NdashTheme.of(context)!.body2Style.copyWith(fontSize: 14.0),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
