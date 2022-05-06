import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ndash/src/common/theme/ndash_theme.dart';
import 'package:ndash/src/common/translation/ndash_localizations.dart';
import 'package:ndash/src/common/utils/email_validator.dart';
import 'package:ndash/src/common/utils/widget_binding_support.dart';
import 'package:ndash/src/common/widgets/ndash_icons.dart';
import 'package:ndash/src/ndash_provider.dart';

enum InputComponentType { feedback, email }

class InputComponent extends StatefulWidget {
  final InputComponentType type;
  final GlobalKey<FormState> formKey;
  final FocusNode focusNode;
  final String? prefill;
  final bool autofocus;

  const InputComponent({
    Key? key,
    required this.type,
    required this.formKey,
    required this.focusNode,
    this.prefill,
    this.autofocus = false,
  }) : super(key: key);

  @override
  _InputComponentState createState() => _InputComponentState();
}

class _InputComponentState extends State<InputComponent> {
  late TextEditingController _textEditingController;

  static const _maxInputLength = 2048;
  static const _lengthWarningThreshold = 50;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.prefill);
    widgetsBindingInstance.addPostFrameCallback((timeStamp) {
      if (widget.autofocus) {
        widget.focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interactiveTextSelectionSupported =
        Localizations.of<MaterialLocalizations>(context, MaterialLocalizations) != null;

    final ndashTheme = NdashTheme.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Form(
        key: widget.formKey,
        child: TextFormField(
          key: const ValueKey('ndash.sdk.text_field'),
          controller: _textEditingController,
          focusNode: widget.focusNode,
          style: ndashTheme.inputTextStyle,
          cursorColor: ndashTheme.primaryColor,
          validator: _validateInput,
          onSaved: _handleInput,
          maxLines: widget.type == InputComponentType.email ? 1 : null,
          enableInteractiveSelection: interactiveTextSelectionSupported,
          decoration: InputDecoration(
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ndashTheme.errorColor, width: 2),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ndashTheme.errorColor, width: 2),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ndashTheme.dividerColor, width: 2),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ndashTheme.primaryColor, width: 2),
            ),
            icon: Icon(
              _getIcon(),
              color: ndashTheme.dividerColor,
              size: 20,
            ),
            hintText: _getHintText(),
            hintStyle: ndashTheme.inputHintStyle,
            errorStyle: ndashTheme.inputErrorStyle,
            errorMaxLines: 2,
          ),
          maxLength: _maxInputLength,
          maxLengthEnforcement: MaxLengthEnforcement.none,
          buildCounter: _getCounterText,
          textCapitalization: _getTextCapitalization(),
          keyboardAppearance: NdashTheme.of(context)!.brightness,
          keyboardType: _getKeyboardType(),
        ),
      ),
    );
  }

  TextCapitalization _getTextCapitalization() {
    switch (widget.type) {
      case InputComponentType.feedback:
        return TextCapitalization.sentences;
      case InputComponentType.email:
        return TextCapitalization.none;
    }
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case InputComponentType.feedback:
        return TextInputType.text;
      case InputComponentType.email:
        return TextInputType.emailAddress;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case InputComponentType.feedback:
        return NdashIcons.edit;
      case InputComponentType.email:
        return NdashIcons.email;
    }
  }

  String _getHintText() {
    switch (widget.type) {
      case InputComponentType.feedback:
        return NdashLocalizations.of(context)!.inputHintFeedback;
      case InputComponentType.email:
        return NdashLocalizations.of(context)!.inputHintEmail;
    }
  }

  Widget? _getCounterText(
    /// The build context for the TextField.
    BuildContext context, {

    /// The length of the string currently in the input.
    required int currentLength,

    /// The maximum string length that can be entered into the TextField.
    required int? maxLength,

    /// Whether or not the TextField is currently focused.  Mainly provided for
    /// the [liveRegion] parameter in the [Semantics] widget for accessibility.
    required bool isFocused,
  }) {
    final theme = NdashTheme.of(context)!;
    final max = maxLength ?? _maxInputLength;
    switch (widget.type) {
      case InputComponentType.feedback:
        final difference = max - currentLength;
        return difference <= _lengthWarningThreshold
            ? Text(
                '$currentLength / $_maxInputLength',
                style: currentLength > max
                    ? theme.inputHintStyle.copyWith(color: theme.errorColor)
                    : theme.inputHintStyle,
              )
            : null;
      default:
        return null;
    }
  }

  String? _validateInput(String? input) {
    final text = input ?? "";
    switch (widget.type) {
      case InputComponentType.feedback:
        if (text.trim().isEmpty) {
          return NdashLocalizations.of(context)!.validationHintFeedbackEmpty;
        } else if (text.characters.length > _maxInputLength) {
          return NdashLocalizations.of(context)!.validationHintFeedbackLength;
        }
        break;
      case InputComponentType.email:
        if (text.isEmpty) {
          // It's okay to not provide an email address, in which we consider the
          // input to be valid.
          return null;
        }

        // If the email is non-null, we validate it.
        return debugEmailValidator.validate(text)
            ? null
            : NdashLocalizations.of(context)!.validationHintEmail;
    }

    return null;
  }

  void _handleInput(String? input) {
    switch (widget.type) {
      case InputComponentType.feedback:
        context.feedbackModel!.feedbackMessage = input;
        break;
      case InputComponentType.email:
        context.userManager!.userEmail = input;
        break;
    }
  }
}

@visibleForTesting
EmailValidator debugEmailValidator = const EmailValidator();
