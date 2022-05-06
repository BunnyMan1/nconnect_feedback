import 'package:flutter/material.dart';
import 'package:ndash/src/common/options/ndash_options.dart';
import 'package:ndash/src/common/translation/l10n/messages_en.dart';
import 'package:ndash/ndash.dart';

class NdashLocalizations extends StatelessWidget {
  const NdashLocalizations({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final options = NdashOptions.of(context);
    return _InheritedNdashTranslation(
      customTranslations: options?.customTranslations,
      child: child,
    );
  }

  static NdashTranslations? of(BuildContext context) {
    final options = NdashOptions.of(context);
    final _InheritedNdashTranslation? inheritedTranslation =
        context.dependOnInheritedWidgetOfExactType<_InheritedNdashTranslation>();
    return inheritedTranslation?.translation(options?.currentLocale);
  }

  /// Checks if given [locale] is supported by its langaugeCode
  static bool isSupported(Locale locale) => _isSupported(locale);

  static bool _isSupported(Locale locale) {
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }

  /// List of currently supported locales by nDash
  static List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }
}

class _InheritedNdashTranslation extends InheritedWidget {
  _InheritedNdashTranslation({
    Key? key,
    required Map<Locale, NdashTranslations>? customTranslations,
    required Widget child,
  }) : super(key: key, child: child) {
    final defaultTranslations = <Locale, NdashTranslations>{
      const Locale.fromSubtags(languageCode: 'en'): const NdashLocalizedTranslations(),
    };
    _translations.addAll(defaultTranslations);

    if (customTranslations != null) {
      _translations.addAll(customTranslations);
    }
  }

  final Map<Locale, NdashTranslations> _translations = <Locale, NdashTranslations>{};

  NdashTranslations translation(Locale? locale) {
    if (locale != null) {
      if (_translations.containsKey(locale)) {
        return _translations[locale]!;
      } else if (NdashLocalizations.isSupported(locale)) {
        final translation =
            _translations[Locale.fromSubtags(languageCode: locale.languageCode)];
        if (translation != null) {
          return translation;
        }
      }
    }
    return _translations[const Locale.fromSubtags(languageCode: 'en')]!;
  }

  @override
  bool updateShouldNotify(_InheritedNdashTranslation oldWidget) =>
      _translations != oldWidget._translations;
}
