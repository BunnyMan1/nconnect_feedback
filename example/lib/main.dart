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
      token:
          "eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiOTA4MyIsInVzZXJfbnVtYmVyIjoiNTAwODAwNDQ1IiwidXNlcl9zZXJpYWxfbnVtYmVyIjoiNDUwMTcwIiwidW5pcXVlX251bWJlciI6IjQwMTE4OCIsImRldmljZV9pZCI6InZzY29kZSIsImxvZ2luX3N0YXRpc3RpY19pZCI6IjM4MzUyMyIsImFwcGxpY2F0aW9uX2lkIjoiMyIsImFwcGxpY2F0aW9uX3BsYXRmb3JtX2lkIjoiMSIsImV4cCI6MTY3MjA1NTUyMiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo1MDAwLyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTAwMC8ifQ.okoQR8ckX8hCYvqrmCQCa3q8vHDiG-i4nLrmji8Wh-I",
      userAgent: "some user agent",
      appVersion: '1.0.0',
      appId: 2,
      studentAdmissionNumber: '12345678',
      options: NdashOptionsData(
        /// Change the locale of the Ndash UI
        locale: const Locale('en'),
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
