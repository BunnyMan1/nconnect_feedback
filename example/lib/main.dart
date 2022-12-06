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
    /// The navigator key is also required to be able to show the overlay.
    /// `_navigatorKey` is assigned to both `Ndash` and `MaterialApp`.
    /// Note: you are not required to use `MaterialApp`,
    return Ndash(
      navigatorKey: _navigatorKey,
      options: NdashOptionsData(
        /// Change the locale of the Ndash UI
        locale: const Locale('en'),
      ),
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        home: const _HomePage(),
      ),
      mediaUrl: 'http://172.40.42.57:5000/api/common/v1/media',
      feedbackSubmitUrl: "http://172.40.42.57:5000/api/common/v1/feedback",
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
        onPressed: () {
          var nd = Ndash.of(context);
          nd?.setUserProperties(
            appId: 2,
            appVersion: "1.1.1",
            userAgent: "Ranadeep thammudu",
            sdkVersion: "1.1",
            token:
                "eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiODc4OTA5ODciLCJ1c2VyX251bWJlciI6IjUwMDgwMTgxNSIsInVzZXJfc2VyaWFsX251bWJlciI6IjcyNDYxNiIsInVuaXF1ZV9udW1iZXIiOiI2NjU3MzQiLCJkZXZpY2VfaWQiOiJ2c2NvZGUiLCJsb2dpbl9zdGF0aXN0aWNfaWQiOiIzODM3ODIiLCJhcHBsaWNhdGlvbl9pZCI6IjMiLCJhcHBsaWNhdGlvbl9wbGF0Zm9ybV9pZCI6IjEiLCJ1c2VyX3R5cGUiOiIyIiwiZXhwIjoxNjcyOTg5NTg2LCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjUwMDAvIiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdDo1MDAwLyJ9.dEnj1icYNLjfpWVS9tnuDUkK3ccbq3EdxTSa1uZS44I",
          );
          nd!.show();
        },

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
