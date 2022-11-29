import 'package:file/local.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ndash/src/capture/capture.dart';
import 'package:ndash/src/common/build_info/build_info_manager.dart';
import 'package:ndash/src/common/device_info/device_info_generator.dart';
import 'package:ndash/src/common/network/api.dart';
import 'package:ndash/src/common/options/ndash_options.dart';
import 'package:ndash/src/common/options/ndash_options_data.dart';
import 'package:ndash/src/common/theme/ndash_theme.dart';
import 'package:ndash/src/common/theme/ndash_theme_data.dart';
import 'package:ndash/src/common/translation/ndash_localizations.dart';
import 'package:ndash/src/common/user/user_manager.dart';
import 'package:ndash/src/common/utils/build_info.dart';
import 'package:ndash/src/common/utils/project_credential_validator.dart';
import 'package:ndash/src/common/utils/widget_binding_support.dart';
import 'package:ndash/src/common/widgets/ndash_scaffold.dart';
import 'package:ndash/src/feedback/data/direct_feedback_submitter.dart';
import 'package:ndash/src/feedback/data/pending_feedback_item_storage.dart';
import 'package:ndash/src/feedback/data/retrying_feedback_submitter.dart';
import 'package:ndash/src/feedback/feedback_model.dart';
import 'package:ndash/src/ndash_controller.dart';
import 'package:ndash/src/ndash_provider.dart';

class Ndash extends StatefulWidget {
  /// Creates a new [Ndash] Widget which allows users to send feedback,
  /// wishes, ratings and much more
  const Ndash({
    Key? key,
    required this.projectId,
    required this.secret,
    required this.navigatorKey,
    this.options,
    this.theme,
    required this.child,
    required this.appVersion,
    required this.studentAdmissionNumber,
    required this.token,
    required this.userAgent,
  }) : super(key: key);

  /// USER AGENT for the APP (String from FkUserAgent)
  final String userAgent;

  final String studentAdmissionNumber;

  final String appVersion;

  final String token;

  /// Reference to the app [Navigator] to show the nDash bottom sheet
  final GlobalKey<NavigatorState> navigatorKey;

  /// Your nDash projectId
  final String projectId;

  /// Your nDash project secret
  final String secret;

  /// Customize nDash's behaviour and language
  final NdashOptionsData? options;

  /// Default visual properties, like colors and fonts for the nDash bottom
  /// sheet and the screenshot capture UI.
  ///
  /// Dark and light themes are supported, try it!
  ///
  /// ```dart
  /// return Ndash(
  ///   theme: NdashThemeData(brightness: Brightness.dark),
  ///   projectId: "...",
  ///   secret: "...",
  ///   child: MyApp(),
  /// );
  /// ```
  final NdashThemeData? theme;

  /// Your application
  final Widget child;

  @override
  NdashState createState() => NdashState();

  /// The [NdashController] from the closest [Ndash] instance that
  /// encloses the given context.
  ///
  /// Use it to start Ndash
  ///
  /// ```dart
  /// Ndash.of(context).show();
  /// ```
  static NdashController? of(BuildContext context) {
    final state = context.findAncestorStateOfType<NdashState>();
    if (state == null) return null;
    return NdashController(state);
  }
}

class NdashState extends State<Ndash> {
  late GlobalKey<CaptureState> captureKey;
  late GlobalKey<NavigatorState> navigatorKey;

  late UserManager userManager;
  late BuildInfoManager buildInfoManager;

  late NdashApi _api;
  late FeedbackModel _feedbackModel;

  late NdashOptionsData _options;
  late NdashThemeData _theme;

  @override
  void initState() {
    super.initState();
    debugProjectCredentialValidator.validate(
      projectId: widget.projectId,
    );

    captureKey = GlobalKey<CaptureState>();
    navigatorKey = widget.navigatorKey;

    _updateDependencies();

    _api = NdashApi(
      // httpClient: Client(),
      projectId: widget.projectId,
      secret: "",
    );

    userManager = UserManager();
    buildInfoManager = BuildInfoManager(PlatformBuildInfo());

    const fileSystem = LocalFileSystem();
    final storage = PendingFeedbackItemStorage(
      fileSystem,
      SharedPreferences.getInstance,
      () async => (await getApplicationDocumentsDirectory()).path,
    );

    final feedbackSubmitter = kIsWeb
        ? DirectFeedbackSubmitter(_api)
        : (RetryingFeedbackSubmitter(fileSystem, storage, _api)..submitPendingFeedbackItems());

    _feedbackModel = FeedbackModel(
      captureKey,
      navigatorKey,
      userManager,
      feedbackSubmitter,
      DeviceInfoGenerator(
        buildInfoManager,
        widgetsBindingInstance.window,
      ),
      userAgent: widget.userAgent,
      appVersion: widget.appVersion,
      studentAdmissionNumber: widget.studentAdmissionNumber,
      token: widget.token,
    );
  }

  @override
  void dispose() {
    _feedbackModel.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Ndash oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateDependencies();
  }

  void _updateDependencies() {
    setState(() {
      _options = widget.options ?? NdashOptionsData();
      _theme = widget.theme ?? NdashThemeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return NdashProvider(
      userManager: userManager,
      feedbackModel: _feedbackModel,
      child: NdashOptions(
        data: _options,
        child: NdashLocalizations(
          child: NdashTheme(
            data: _theme,
            child: NdashScaffold(
              child: Capture(
                key: captureKey,
                initialColor: _theme.firstPenColor,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void show() {
    _feedbackModel.show();
  }
}

@visibleForTesting
ProjectCredentialValidator debugProjectCredentialValidator = const ProjectCredentialValidator();
