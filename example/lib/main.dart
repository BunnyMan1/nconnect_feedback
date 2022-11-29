import 'package:flutter/material.dart';
import 'package:ndash/ndash.dart';

void main() {
  runApp(const NdashExampleApp());
}

class NdashExampleApp extends StatefulWidget {
  const NdashExampleApp({Key? key}) : super(key: key);

  @override
  _NdashExampleAppState createState() => _NdashExampleAppState();
}

class _NdashExampleAppState extends State<NdashExampleApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    /// The `Ndash` widget wraps the top level application widget.
    ///
    /// `Ndash` requires the `Project ID` and the `API Key` obtained from the
    /// "Settings" tab of the console.
    /// The navigator key is also required to be able to show the overlay.
    /// `_navigatorKey` is assigned to both `Ndash` and `MaterialApp`.
    /// Note: you are not required to use `MaterialApp`,
    /// Ndash will work just as well with `CupertinoApp` and `WidgetsApp`.
    ///
    /// Ndash also allows you to set custom themes using `NdashThemeData`.
    /// The behaviour as well as the locale and translations can be customized
    /// using `NdashOptionsData`.
    /// Both of these are optional but they enable you to make Ndash your
    /// own.
    /// Read more about translations support in the package's README.
    return Ndash(
      projectId: "Project ID from console.Ndash.io",
      secret: "API Key from console.Ndash.io",
      navigatorKey: _navigatorKey,
      token:
          "eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiOTA4MyIsInVzZXJfbnVtYmVyIjoiNTAwODAwNDQ1IiwidXNlcl9zZXJpYWxfbnVtYmVyIjoiNDUwMTcwIiwidW5pcXVlX251bWJlciI6IjQwMTE4OCIsImRldmljZV9pZCI6InZzY29kZSIsImxvZ2luX3N0YXRpc3RpY19pZCI6IjM4MzUyMyIsImFwcGxpY2F0aW9uX2lkIjoiMyIsImFwcGxpY2F0aW9uX3BsYXRmb3JtX2lkIjoiMSIsImV4cCI6MTY3MjA1NTUyMiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo1MDAwLyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTAwMC8ifQ.okoQR8ckX8hCYvqrmCQCa3q8vHDiG-i4nLrmji8Wh-I",
      userAgent: "some user agent",
      appVersion: '1.0.0',
      studentAdmissionNumber: '12345678',
      options: NdashOptionsData(
        /// Change the locale of the Ndash UI
        locale: const Locale('en'),

        /// Uncomment below to disable the screenshot step
        // screenshotStep: false,

        /// Uncomment below to disable different buttons
        // bugReportButton: false,
        // featureRequestButton: false,
        // praiseButton: false,

        /// Uncomment below to set custom translations work
        // customTranslations: {
        //   const Locale.fromSubtags(languageCode: 'en'):
        //       const CustomDemoTranslations(),
        // },

        /// Uncomment below to override the default device locale
        // and/or text direction
        // locale: const Locale('de'),
        // textDirection: TextDirection.rtl,
      ),
      theme: NdashThemeData(

          /// Uncomment below to explore the various theme options:

          /// Customize the Font Family
          // fontFamily: 'Monospace',

          /// Customize the Bottom Sheet Border Radius
          // sheetBorderRadius: BorderRadius.zero,

          /// Customize Brightness and Colors
          // brightness: Brightness.light,
          // primaryColor: Colors.red,
          // secondaryColor: Colors.blue,

          /// Customize the Pen Colors
          /// Note: If you change the Pen Colors, please consider providing
          /// custom translations to the NdashOptions to ensure the app is
          /// accessible to all. The default translations describe the default
          /// pen colors.
          // firstPenColor: Colors.orange,
          // secondPenColor: Colors.green,
          // thirdPenColor: Colors.yellow,
          // fourthPenColor: Colors.deepPurpleAccent,
          ),
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        home: const _HomePage(),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ndash Demo'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Sample Item #$index'),
            subtitle: const Text('Tap me to open a new page'),
            onTap: () => _openDetailsPage(context, index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        /// Showing the Ndash Dialog is as easy as calling:
        /// Ndash.of(context).show()
        /// Since the `Ndash` widget is at the root of the widget tree this
        /// method can be accessed from anywhere in the code.
        onPressed: Ndash.of(context)!.show,
        child: const Icon(Icons.feedback_outlined),
      ),
    );
  }

  void _openDetailsPage(BuildContext context, int which) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return _DetailsPage(index: which);
        },
      ),
    );
  }
}

class _DetailsPage extends StatelessWidget {
  const _DetailsPage({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Page #$index'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Details page #$index',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 8),
              const Text('Try navigating here in feedback mode.')
            ],
          ),
        ),
      ),
    );
  }
}
