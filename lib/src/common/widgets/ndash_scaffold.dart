import 'package:flutter/widgets.dart';
import 'package:ndash/src/common/options/ndash_options.dart';
import 'package:ndash/src/common/theme/ndash_theme.dart';
import 'package:ndash/src/common/utils/widget_binding_support.dart';

class NdashScaffold extends StatefulWidget {
  const NdashScaffold({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _NdashScaffoldState createState() => _NdashScaffoldState();
}

class _NdashScaffoldState extends State<NdashScaffold>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromWindow(widgetsBindingInstance.window),
      child: Directionality(
        textDirection: NdashOptions.of(context)!.textDirection,
        child: Container(
          color: NdashTheme.of(context)!.backgroundColor,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widgetsBindingInstance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    setState(() {
      // Update when MediaQuery properties change
    });
  }

  @override
  void dispose() {
    widgetsBindingInstance.removeObserver(this);
    super.dispose();
  }
}
