import 'package:flutter/material.dart';
import 'package:ndash/src/common/options/ndash_options.dart';
import 'package:ndash/src/common/renderer/renderer.dart';
import 'package:ndash/src/common/theme/ndash_theme.dart';
import 'package:ndash/src/common/translation/ndash_localizations.dart';
import 'package:ndash/src/common/widgets/animated_fade_in.dart';
import 'package:ndash/src/common/widgets/animated_progress.dart';
import 'package:ndash/src/common/widgets/navigation_buttons.dart';
import 'package:ndash/src/common/widgets/ndash_icons.dart';
import 'package:ndash/src/feedback/components/error_component.dart';
import 'package:ndash/src/feedback/components/input_component.dart';
import 'package:ndash/src/feedback/components/intro_component.dart';
import 'package:ndash/src/feedback/components/loading_component.dart';
import 'package:ndash/src/feedback/components/success_component.dart';
import 'package:ndash/src/feedback/feedback_model.dart';
import 'package:ndash/src/ndash_provider.dart';

class FeedbackSheet extends StatefulWidget {
  const FeedbackSheet({Key? key}) : super(key: key);

  @override
  _FeedbackSheetState createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<FeedbackSheet>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final _emailFormKey = GlobalKey<FormState>();
  final _feedbackFormKey = GlobalKey<FormState>();

  final _feedbackFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _feedbackFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: NdashTheme.of(context)!.secondaryBackgroundColor,
        borderRadius: NdashTheme.of(context)!.sheetBorderRadius,
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          top: false,
          left: false,
          right: false,
          minimum: const EdgeInsets.only(bottom: 16),
          child: _buildCardContent(),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return Column(
      children: <Widget>[
        _buildHeader(),
        AnimatedBuilder(
          animation: context.feedbackModel!,
          builder: (context, _) {
            return AnimatedProgress(
              isLoading: context.feedbackModel!.loading,
              value: _getProgressValue(),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AnimatedSize(
            // remove when min Flutter SDK is after v2.2.0-10.1.pre
            // ignore: deprecated_member_use
            // vsync: this,
            alignment: Alignment.topCenter,
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 350),
            child: AnimatedBuilder(
              animation: context.feedbackModel!,
              builder: (context, _) => Column(
                children: <Widget>[
                  _getInputComponent(),
                  _buildButtons(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            NdashTheme.of(context)!.primaryColor,
            NdashTheme.of(context)!.secondaryColor
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            child: Material(
              shape: const StadiumBorder(),
              color: NdashTheme.of(context)!.dividerColor,
              child: const SizedBox(
                height: 4,
                width: 56,
              ),
            ),
          ),
          const SizedBox(height: 24),
          AnimatedBuilder(
            animation: context.feedbackModel!,
            builder: (context, child) => AnimatedFadeIn(
              changeKey: ValueKey(context.feedbackModel!.feedbackUiState),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 250),
                // remove when min Flutter SDK is after v2.2.0-10.1.pre
                // ignore: deprecated_member_use
                // vsync: this,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _getTitle(),
                      style: NdashTheme.of(context)!.titleStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getSubtitle(),
                      style: NdashTheme.of(context)!.subtitleStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    final state = context.feedbackModel!;

    switch (state.feedbackUiState) {
      case FeedbackUiState.feedback:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PreviousButton(
                text: NdashLocalizations.of(context)!.feedbackCancel,
                onPressed: () => state.feedbackUiState = FeedbackUiState.intro,
              ),
            ),
            Expanded(
              child: NextButton(
                key: const ValueKey('ndash.sdk.save_feedback_button'),
                text: NdashLocalizations.of(context)!.feedbackSave,
                icon: NdashIcons.right,
                onPressed: _submitFeedback,
              ),
            ),
          ],
        );
      case FeedbackUiState.email:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PreviousButton(
                text: NdashLocalizations.of(context)!.feedbackBack,
                onPressed: () =>
                    state.feedbackUiState = FeedbackUiState.feedback,
              ),
            ),
            Expanded(
              child: NextButton(
                key: const ValueKey('ndash.sdk.send_feedback_button'),
                text: NdashLocalizations.of(context)!.feedbackSend,
                icon: NdashIcons.right,
                onPressed: _submitEmail,
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _submitFeedback() {
    if (_feedbackFormKey.currentState!.validate()) {
      _feedbackFormKey.currentState!.save();
      context.feedbackModel!.feedbackUiState = FeedbackUiState.email;
    }
  }

  void _submitEmail() {
    if (_emailFormKey.currentState!.validate()) {
      _emailFormKey.currentState!.save();
      context.feedbackModel!.feedbackUiState = FeedbackUiState.submit;
    }
  }

  void _onFeedbackModeSelected(FeedbackType mode) {
    final feedbackModel = context.feedbackModel;
    feedbackModel!.feedbackType = mode;

    switch (mode) {
      case FeedbackType.bug:
      case FeedbackType.improvement:
        final renderer = getRenderer();
        if (NdashOptions.of(context)!.screenshotStep &&
            renderer != Renderer.html) {
          // Start the capture process
          Navigator.pop(context);
          feedbackModel.feedbackUiState = FeedbackUiState.capture;
        } else {
          // Don't start the screen capturing and directly continue to the
          // feedback form
          feedbackModel.feedbackUiState = FeedbackUiState.feedback;
        }
        break;
      case FeedbackType.praise:
        // Don't start the screen capturing and directly continue to the
        // feedback form
        feedbackModel.feedbackUiState = FeedbackUiState.feedback;
        break;
    }
  }

  String _getTitle() {
    switch (context.feedbackModel!.feedbackUiState) {
      case FeedbackUiState.intro:
        return NdashLocalizations.of(context)!.feedbackStateIntroTitle;
      case FeedbackUiState.feedback:
        return NdashLocalizations.of(context)!.feedbackStateFeedbackTitle;
      case FeedbackUiState.email:
        return NdashLocalizations.of(context)!.feedbackStateEmailTitle;
      case FeedbackUiState.submit:
      case FeedbackUiState.submitted:
        return NdashLocalizations.of(context)!.feedbackStateSuccessTitle;
      case FeedbackUiState.submissionError:
        return NdashLocalizations.of(context)!.feedbackStateErrorTitle;
      default:
        return '';
    }
  }

  String _getSubtitle() {
    switch (context.feedbackModel!.feedbackUiState) {
      case FeedbackUiState.intro:
        return NdashLocalizations.of(context)!.feedbackStateIntroMsg;
      case FeedbackUiState.feedback:
        return NdashLocalizations.of(context)!.feedbackStateFeedbackMsg;
      case FeedbackUiState.email:
        return NdashLocalizations.of(context)!.feedbackStateEmailMsg;
      case FeedbackUiState.submit:
      case FeedbackUiState.submitted:
        return NdashLocalizations.of(context)!.feedbackStateSuccessMsg;
      case FeedbackUiState.submissionError:
        return NdashLocalizations.of(context)!.feedbackStateErrorMsg;
      default:
        return '';
    }
  }

  double _getProgressValue() {
    switch (context.feedbackModel!.feedbackUiState) {
      case FeedbackUiState.feedback:
        return 0.3;
      case FeedbackUiState.email:
        return 0.7;
      case FeedbackUiState.submit:
        return 0.9;
      case FeedbackUiState.submissionError:
        return 0.9;
      case FeedbackUiState.submitted:
        return 1.0;
      default:
        return 0;
    }
  }

  Widget _getInputComponent() {
    final uiState = context.feedbackModel!.feedbackUiState;
    switch (uiState) {
      case FeedbackUiState.intro:
        return IntroComponent(_onFeedbackModeSelected);
      case FeedbackUiState.feedback:
        return InputComponent(
          key: const ValueKey('ndash.sdk.feedback_input_field'),
          type: InputComponentType.feedback,
          formKey: _feedbackFormKey,
          focusNode: _feedbackFocusNode,
          prefill: context.feedbackModel!.feedbackMessage,
          autofocus: _emailFocusNode.hasFocus,
        );
      case FeedbackUiState.email:
        return InputComponent(
          key: const ValueKey('ndash.sdk.email_input_field'),
          type: InputComponentType.email,
          formKey: _emailFormKey,
          focusNode: _emailFocusNode,
          prefill: context.userManager!.userEmail,
          autofocus: _feedbackFocusNode.hasFocus,
        );
      case FeedbackUiState.submit:
        return const LoadingComponent();
      case FeedbackUiState.submitted:
        return SuccessComponent(
          () {
            context.feedbackModel!.feedbackUiState = FeedbackUiState.hidden;
            Navigator.pop(context);
          },
        );
      case FeedbackUiState.submissionError:
        return ErrorComponent(
          onRetry: () {
            context.feedbackModel!.feedbackUiState = FeedbackUiState.submit;
          },
        );
      default:
        return IntroComponent(_onFeedbackModeSelected);
    }
  }
}
