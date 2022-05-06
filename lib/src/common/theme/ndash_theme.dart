import 'package:flutter/widgets.dart';
import 'package:ndash/src/common/theme/ndash_theme_data.dart';

class NdashTheme extends StatelessWidget {
  const NdashTheme({
    Key? key,
    required this.data,
    required this.child,
  }) : super(key: key);

  final NdashThemeData data;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _InheritedNdashTheme(theme: this, child: child);
  }

  static NdashThemeData? of(BuildContext context) {
    final _InheritedNdashTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedNdashTheme>();
    return inheritedTheme?.theme.data;
  }
}

class _InheritedNdashTheme extends InheritedWidget {
  const _InheritedNdashTheme({
    Key? key,
    required this.theme,
    required Widget child,
  }) : super(key: key, child: child);

  final NdashTheme theme;

  @override
  bool updateShouldNotify(_InheritedNdashTheme oldWidget) =>
      theme != oldWidget.theme;
}
