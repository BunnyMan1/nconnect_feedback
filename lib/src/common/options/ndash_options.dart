import 'package:flutter/widgets.dart';
import 'package:ndash/src/common/options/ndash_options_data.dart';

class NdashOptions extends StatelessWidget {
  const NdashOptions({
    Key? key,
    required this.data,
    required this.child,
  }) : super(key: key);

  final NdashOptionsData data;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _InheritedNdashOptions(
      options: this,
      child: child,
    );
  }

  static NdashOptionsData? of(BuildContext context) {
    final _InheritedNdashOptions? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedNdashOptions>();
    return inheritedTheme?.options.data;
  }
}

class _InheritedNdashOptions extends InheritedWidget {
  const _InheritedNdashOptions({
    Key? key,
    required this.options,
    required Widget child,
  }) : super(key: key, child: child);

  final NdashOptions options;

  @override
  bool updateShouldNotify(_InheritedNdashOptions oldWidget) =>
      options != oldWidget.options;
}
