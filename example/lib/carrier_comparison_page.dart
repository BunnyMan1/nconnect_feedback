import 'dart:math' as math;

import 'package:carrier_info/carrier_info.dart' as legacy;
import 'package:carrier_info_plus/carrier_info_plus.dart' as plus;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

bool get _isAndroid =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

/// Reads carrier data through both `carrier_info` and `carrier_info_plus` and
/// lines their fields up side by side, so the gaps between the two packages
/// are visible on a real device.
///
/// A "not in API" cell means the package has no such field at all. A tinted
/// italic value means the field exists but came back null or empty here.
class CarrierComparisonPage extends StatefulWidget {
  const CarrierComparisonPage({super.key});

  @override
  State<CarrierComparisonPage> createState() => _CarrierComparisonPageState();
}

class _CarrierComparisonPageState extends State<CarrierComparisonPage> {
  Future<_Comparison> _comparison = _Comparison.load();
  _Filter _filter = _Filter.all;

  void _reload() => setState(() => _comparison = _Comparison.load());

  Future<void> _requestPermission() async {
    // Permission.phone asks for READ_PHONE_STATE and, on API 30+,
    // READ_PHONE_NUMBERS. carrier_info fails outright without the latter.
    await Permission.phone.request();
    if (mounted) _reload();
  }

  void _showMarkdown(_Comparison comparison) {
    final markdown = comparison.toMarkdown(_filter);
    // Also log it: the device clipboard never reaches your computer (the iOS
    // simulator keeps its own unless "Automatically Sync Pasteboard" is on),
    // but the `flutter run` console does.
    debugPrint(markdown);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => _MarkdownPage(markdown),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_Comparison>(
      future: _comparison,
      builder: (BuildContext context, AsyncSnapshot<_Comparison> snapshot) {
        final comparison = snapshot.data;
        final reloading =
            comparison != null &&
            snapshot.connectionState == ConnectionState.waiting;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Carrier packages'),
            actions: [
              if (_isAndroid)
                IconButton(
                  tooltip: 'Grant phone permission',
                  icon: const Icon(Icons.lock_open_outlined),
                  onPressed: _requestPermission,
                ),
              IconButton(
                tooltip: 'View as Markdown',
                icon: const Icon(Icons.article_outlined),
                onPressed: comparison == null
                    ? null
                    : () => _showMarkdown(comparison),
              ),
              IconButton(
                tooltip: 'Reload',
                icon: const Icon(Icons.refresh),
                onPressed: _reload,
              ),
            ],
            bottom: reloading
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(2),
                    child: LinearProgressIndicator(minHeight: 2),
                  )
                : null,
          ),
          body: comparison != null
              ? _buildBody(comparison)
              : snapshot.hasError
              ? Center(child: Text('${snapshot.error}'))
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildBody(_Comparison comparison) {
    final textTheme = Theme.of(context).textTheme;
    final sections = [
      for (final section in comparison.sections) section.where(_filter),
    ]..removeWhere((_Section section) => section.rows.isEmpty);

    return SelectionArea(
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _SummaryCard(comparison),
          const SizedBox(height: 12),
          SegmentedButton<_Filter>(
            segments: [
              for (final filter in _Filter.values)
                ButtonSegment<_Filter>(
                  value: filter,
                  label: Text(filter.label),
                ),
            ],
            selected: {_filter},
            onSelectionChanged: (Set<_Filter> selection) =>
                setState(() => _filter = selection.single),
          ),
          for (final section in sections) ...[
            const SizedBox(height: 16),
            Text(section.title, style: textTheme.titleSmall),
            const SizedBox(height: 6),
            _ComparisonTable(section.rows),
          ],
        ],
      ),
    );
  }
}

enum _Filter {
  all('All'),
  gaps('Gaps only'),
  shared('Shared');

  const _Filter(this.label);

  final String label;

  bool accepts(_Row row) => switch (this) {
    _Filter.all => true,
    _Filter.gaps => row.isGap,
    _Filter.shared => !row.isGap,
  };
}

// ---------------------------------------------------------------------------
// Model
// ---------------------------------------------------------------------------

/// Stands in for a value when there is nothing to read it from: the call
/// failed, or this package returned fewer SIM entries than the other one.
const Object _missing = _Missing();

class _Missing {
  const _Missing();
}

/// One field read from one package: where it lives, and what it returned.
class _Field {
  const _Field(this.path, this.value);

  final String path;
  final Object? value;
}

/// One concept, e.g. "Carrier name", as each package exposes it.
///
/// An empty field list means the package has no such field at all.
class _Row {
  const _Row(
    this.label, {
    required this.legacyFields,
    required this.plusFields,
  });

  final String label;
  final List<_Field> legacyFields;
  final List<_Field> plusFields;

  bool get isGap => legacyFields.isEmpty || plusFields.isEmpty;
}

class _Section {
  const _Section(this.title, this.rows);

  final String title;
  final List<_Row> rows;

  _Section where(_Filter filter) =>
      _Section(title, rows.where(filter.accepts).toList());
}

class _Comparison {
  _Comparison._({
    required this.legacyData,
    required this.legacyError,
    required this.plusData,
    required this.plusError,
    required this.permission,
  });

  /// Reads both packages concurrently. Never throws: a failed read is kept as
  /// an error so the other package's column still renders.
  static Future<_Comparison> load() async {
    final legacyRead = _attempt(_readLegacy);
    final plusRead = _attempt(plus.CarrierInfoPlus.get);
    final permissionRead = _attempt(
      () async => _isAndroid ? await Permission.phone.status : null,
    );
    final (legacyData, legacyError) = await legacyRead;
    final (plusData, plusError) = await plusRead;
    final (permission, _) = await permissionRead;
    return _Comparison._(
      legacyData: legacyData,
      legacyError: legacyError,
      plusData: plusData,
      plusError: plusError,
      permission: permission,
    );
  }

  static Future<Object?> _readLegacy() => switch (defaultTargetPlatform) {
    TargetPlatform.android => legacy.CarrierInfo.getAndroidInfo(),
    TargetPlatform.iOS => legacy.CarrierInfo.getIosInfo(),
    final platform => throw UnsupportedError(
      'carrier_info does not support ${platform.name}',
    ),
  };

  /// `AndroidCarrierData`, `IosCarrierData`, or null if the call failed.
  final Object? legacyData;
  final Object? legacyError;
  final plus.CarrierInfo? plusData;
  final Object? plusError;

  /// Android only; null elsewhere.
  final PermissionStatus? permission;

  late final List<_Section> sections = _buildSections(switch (legacyData) {
    final legacy.AndroidCarrierData data => _LegacyAndroidSource(data),
    final legacy.IosCarrierData data => _LegacyIosSource(data),
    _ =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? const _LegacyIosSource(null)
          : const _LegacyAndroidSource(null),
  }, _PlusSource(plusData));

  /// Distinct fields per package, counted once per label so the repeated
  /// per-SIM sections do not inflate the numbers.
  late final ({int shared, int legacyOnly, int plusOnly}) coverage = () {
    final rows = {
      for (final section in sections)
        for (final row in section.rows) row.label: row,
    }.values;
    return (
      shared: rows.where((_Row row) => !row.isGap).length,
      legacyOnly: rows.where((_Row row) => row.plusFields.isEmpty).length,
      plusOnly: rows.where((_Row row) => row.legacyFields.isEmpty).length,
    );
  }();

  String toMarkdown(_Filter filter) {
    final buffer = StringBuffer()
      ..writeln('# Carrier packages on ${defaultTargetPlatform.name}')
      ..writeln()
      ..writeln('- carrier_info: ${legacyError ?? 'ok'}')
      ..writeln('- carrier_info_plus: ${plusError ?? 'ok'}');
    if (permission != null) {
      buffer.writeln('- phone permission: ${permission!.name}');
    }
    buffer.writeln(
      '- ${coverage.shared} shared, ${coverage.legacyOnly} only in '
      'carrier_info, ${coverage.plusOnly} only in carrier_info_plus',
    );
    for (final section in sections) {
      final rows = section.rows.where(filter.accepts);
      if (rows.isEmpty) continue;
      buffer
        ..writeln()
        ..writeln('## ${section.title}')
        ..writeln()
        ..writeln('| Field | carrier_info | carrier_info_plus |')
        ..writeln('| --- | --- | --- |');
      for (final row in rows) {
        buffer.writeln(
          '| ${row.label} | ${_markdownCell(row.legacyFields)} '
          '| ${_markdownCell(row.plusFields)} |',
        );
      }
    }
    return buffer.toString();
  }
}

Future<(T?, Object?)> _attempt<T>(Future<T> Function() read) async {
  try {
    return (await read(), null);
  } catch (error) {
    return (null, error);
  }
}

List<_Section> _buildSections(_Source legacySource, _Source plusSource) {
  // Always show at least one SIM section so its field coverage is visible
  // even on a device (or simulator) with no SIM.
  final simCount = math.max(
    1,
    math.max(legacySource.simCount, plusSource.simCount),
  );
  return [
    _merge('Device', legacySource.device, plusSource.device),
    _merge('SIM summary', legacySource.simSummary, plusSource.simSummary),
    _merge('Network', legacySource.network, plusSource.network),
    _merge('Platform support', legacySource.support, plusSource.support),
    for (var i = 0; i < simCount; i++)
      _merge('SIM ${i + 1}', legacySource.sim(i), plusSource.sim(i)),
  ];
}

_Section _merge(String title, _Fields legacyFields, _Fields plusFields) {
  return _Section(title, [
    for (final label in {...plusFields.keys, ...legacyFields.keys})
      _Row(
        label,
        legacyFields: legacyFields[label] ?? const [],
        plusFields: plusFields[label] ?? const [],
      ),
  ]);
}

// ---------------------------------------------------------------------------
// Sources: each package's fields, keyed by the row label they belong to.
// Use the same label on both sides for fields that mean the same thing.
// ---------------------------------------------------------------------------

typedef _Fields = Map<String, List<_Field>>;

abstract class _Source {
  const _Source();

  _Fields get device;
  _Fields get simSummary;
  _Fields get network;
  _Fields get support => const {};

  int get simCount;
  _Fields sim(int index);
}

class _PlusSource extends _Source {
  const _PlusSource(this.info);

  final plus.CarrierInfo? info;

  @override
  _Fields get device => {
    'Voice capable': [
      _field(
        'capabilities.isVoiceCapable',
        info,
        (c) => c.capabilities.isVoiceCapable,
      ),
    ],
    'SMS capable': [
      _field(
        'capabilities.isSmsCapable',
        info,
        (c) => c.capabilities.isSmsCapable,
      ),
    ],
    'Data capable': [
      _field(
        'capabilities.isDataCapable',
        info,
        (c) => c.capabilities.isDataCapable,
      ),
    ],
    'Mobile data enabled': [
      _field(
        'capabilities.isDataEnabled',
        info,
        (c) => c.capabilities.isDataEnabled,
      ),
    ],
    'Multi-SIM supported': [
      _field(
        'capabilities.isMultiSimSupported',
        info,
        (c) => c.capabilities.isMultiSimSupported,
      ),
    ],
    'eSIM supported': [
      _field(
        'capabilities.supportsEmbeddedSim',
        info,
        (c) => c.capabilities.supportsEmbeddedSim,
      ),
    ],
  };

  @override
  _Fields get simSummary => {
    'SIM present': [_field('hasSim', info, (c) => c.hasSim)],
    'Dual SIM active': [
      _field('isDualSimActive', info, (c) => c.isDualSimActive),
    ],
    'SIM count': [
      _field('simCount', info, (c) => c.simCount),
      _field('simCards.length', info, (c) => c.simCards.length),
    ],
  };

  @override
  _Fields get network => {
    'Generation': [
      _field('network.generation', info, (c) => c.network.generation),
    ],
    'Radio technology': [
      _field(
        'network.radioTechnologies',
        info,
        (c) => c.network.radioTechnologies,
      ),
    ],
    'Operator name': [
      _field('network.operatorName', info, (c) => c.network.operatorName),
    ],
    'Network country': [
      _field('network.countryIso', info, (c) => c.network.countryIso),
    ],
    'Cellular data state': [
      _field(
        'network.cellularDataState',
        info,
        (c) => c.network.cellularDataState,
      ),
    ],
    'Connected': [
      _field('network.isConnected', info, (c) => c.network.isConnected),
    ],
  };

  @override
  _Fields get support => {
    'Carrier identity available': [
      _field(
        'support.carrierIdentityAvailable',
        info,
        (c) => c.support.carrierIdentityAvailable,
      ),
    ],
    'Per-SIM data available': [
      _field(
        'support.perSimDataAvailable',
        info,
        (c) => c.support.perSimDataAvailable,
      ),
    ],
    'Permission granted': [
      _field(
        'support.permissionGranted',
        info,
        (c) => c.support.permissionGranted,
      ),
    ],
    'Limitation': [
      _field('support.limitation', info, (c) => c.support.limitation),
    ],
    'Recoverable': [
      _field(
        'support.limitation.isRecoverable',
        info,
        (c) => c.support.limitation.isRecoverable,
      ),
    ],
    'Complete': [
      _field('support.isComplete', info, (c) => c.support.isComplete),
    ],
    'Explanation': [
      _field(
        'support.limitation.explanation',
        info,
        (c) => c.support.limitation.explanation,
      ),
    ],
  };

  @override
  int get simCount => info?.simCards.length ?? 0;

  @override
  _Fields sim(int index) {
    final sim = _at(info?.simCards, index);
    _Field field(String name, Object? Function(plus.SimCard sim) read) =>
        _field('simCards[$index].$name', sim, read);
    return {
      'Subscription ID': [field('subscriptionId', (s) => s.subscriptionId)],
      'Slot index': [field('slotIndex', (s) => s.slotIndex)],
      'Carrier name': [field('carrierName', (s) => s.carrierName)],
      'Display name': [field('displayName', (s) => s.displayName)],
      'MCC': [field('mobileCountryCode', (s) => s.mobileCountryCode)],
      'MNC': [field('mobileNetworkCode', (s) => s.mobileNetworkCode)],
      'PLMN': [field('plmn', (s) => s.plmn)],
      'SIM country': [field('countryIso', (s) => s.countryIso)],
      'Carrier ID': [field('carrierId', (s) => s.carrierId)],
      'eSIM': [field('isEmbedded', (s) => s.isEmbedded)],
      'Roaming': [field('isRoaming', (s) => s.isRoaming)],
      'Default data SIM': [field('isDefaultData', (s) => s.isDefaultData)],
      'Default voice SIM': [field('isDefaultVoice', (s) => s.isDefaultVoice)],
      'SIM state': [field('state', (s) => s.state)],
      'Has identity': [field('hasIdentity', (s) => s.hasIdentity)],
    };
  }
}

class _LegacyAndroidSource extends _Source {
  const _LegacyAndroidSource(this.data);

  final legacy.AndroidCarrierData? data;

  @override
  _Fields get device => {
    'Voice capable': [_field('isVoiceCapable', data, (d) => d.isVoiceCapable)],
    'SMS capable': [_field('isSmsCapable', data, (d) => d.isSmsCapable)],
    'Data capable': [_field('isDataCapable', data, (d) => d.isDataCapable)],
    'Mobile data enabled': [
      _field('isDataEnabled', data, (d) => d.isDataEnabled),
    ],
    'Multi-SIM supported': [
      _field('isMultiSimSupported', data, (d) => d.isMultiSimSupported),
    ],
  };

  @override
  _Fields get simSummary => {
    'SIM count': [
      _field(
        'subscriptionsInfo.length',
        data,
        (d) => d.subscriptionsInfo.length,
      ),
      _field('telephonyInfo.length', data, (d) => d.telephonyInfo.length),
    ],
  };

  @override
  _Fields get network {
    List<_Field> each(
      String name,
      Object? Function(legacy.TelephonyInfo info) read,
    ) => _each('telephonyInfo', name, data?.telephonyInfo, read);
    return {
      'Generation': each('networkGeneration', (t) => t.networkGeneration),
      'Radio technology': each('radioType', (t) => t.radioType),
      'Operator name': each(
        'networkOperatorName',
        (t) => t.networkOperatorName,
      ),
      'Network country': each('networkCountryIso', (t) => t.networkCountryIso),
      'Cell ID': each('cellId', (t) => t.cellId),
    };
  }

  @override
  int get simCount => math.max(
    data?.subscriptionsInfo.length ?? 0,
    data?.telephonyInfo.length ?? 0,
  );

  @override
  _Fields sim(int index) {
    final subscription = _at(data?.subscriptionsInfo, index);
    final telephony = _at(data?.telephonyInfo, index);
    _Field sub(
      String name,
      Object? Function(legacy.SubscriptionsInfo s) read,
    ) => _field('subscriptionsInfo[$index].$name', subscription, read);
    _Field tel(String name, Object? Function(legacy.TelephonyInfo t) read) =>
        _field('telephonyInfo[$index].$name', telephony, read);
    return {
      'Subscription ID': [
        sub('subscriptionId', (s) => s.subscriptionId),
        tel('subscriptionId', (t) => t.subscriptionId),
      ],
      'Slot index': [sub('simSlotIndex', (s) => s.simSlotIndex)],
      'Carrier name': [tel('carrierName', (t) => t.carrierName)],
      'Display name': [
        sub('displayName', (s) => s.displayName),
        tel('displayName', (t) => t.displayName),
      ],
      'MCC': [
        sub('mobileCountryCode', (s) => s.mobileCountryCode),
        tel('mobileCountryCode', (t) => t.mobileCountryCode),
      ],
      'MNC': [
        sub('mobileNetworkCode', (s) => s.mobileNetworkCode),
        tel('mobileNetworkCode', (t) => t.mobileNetworkCode),
      ],
      'SIM country': [
        sub('countryIso', (s) => s.countryIso),
        tel('isoCountryCode', (t) => t.isoCountryCode),
      ],
      'Carrier ID': [sub('carrierId', (s) => s.carrierId)],
      'eSIM': [sub('isEmbedded', (s) => s.isEmbedded)],
      'Roaming': [sub('isNetworkRoaming', (s) => s.isNetworkRoaming)],
      'SIM state': [tel('simState', (t) => t.simState)],
      'Phone number': [
        sub('phoneNumber', (s) => s.phoneNumber),
        tel('phoneNumber', (t) => t.phoneNumber),
      ],
      'ICCID': [sub('simSerialNo', (s) => s.simSerialNo)],
      'Card ID': [sub('cardId', (s) => s.cardId)],
      'Subscription type': [sub('subscriptionType', (s) => s.subscriptionType)],
      'Opportunistic': [sub('isOpportunistic', (s) => s.isOpportunistic)],
      'Data roaming setting': [sub('dataRoaming', (s) => s.dataRoaming)],
    };
  }
}

class _LegacyIosSource extends _Source {
  const _LegacyIosSource(this.data);

  final legacy.IosCarrierData? data;

  @override
  _Fields get device => {
    'eSIM supported': [
      _field('supportsEmbeddedSIM', data, (d) => d.supportsEmbeddedSIM),
      _field(
        'cellularPlanInfo.supportsEmbeddedSIM',
        data,
        (d) => d.cellularPlanInfo?.supportsEmbeddedSIM,
      ),
    ],
  };

  @override
  _Fields get simSummary => {
    'SIM present': [_field('isSIMInserted', data, (d) => d.isSIMInserted)],
    'SIM count': [
      _field('carrierData.length', data, (d) => d.carrierData.length),
      _field(
        'subscriberInfo.subscriberCount',
        data,
        (d) => d.subscriberInfo?.subscriberCount,
      ),
    ],
    'Subscriber identifiers': [
      _field(
        'subscriberInfo.subscriberIdentifiers',
        data,
        (d) => d.subscriberInfo?.subscriberIdentifiers,
      ),
    ],
    'Carrier tokens': [
      _field(
        'subscriberInfo.carrierTokens',
        data,
        (d) => d.subscriberInfo?.carrierTokens,
      ),
    ],
  };

  @override
  _Fields get network => {
    'Radio technology': [
      _field(
        'carrierRadioAccessTechnologyTypeList',
        data,
        (d) => d.carrierRadioAccessTechnologyTypeList,
      ),
      _field(
        'networkStatus.technologies',
        data,
        (d) => d.networkStatus?.technologies,
      ),
    ],
    'Has cellular data': [
      _field(
        'networkStatus.hasCellularData',
        data,
        (d) => d.networkStatus?.hasCellularData,
      ),
    ],
    'Active services': [
      _field(
        'networkStatus.activeServices',
        data,
        (d) => d.networkStatus?.activeServices,
      ),
    ],
  };

  @override
  int get simCount => data?.carrierData.length ?? 0;

  @override
  _Fields sim(int index) {
    final carrier = _at(data?.carrierData, index);
    _Field field(String name, Object? Function(legacy.CarrierData c) read) =>
        _field('carrierData[$index].$name', carrier, read);
    return {
      'Carrier name': [field('carrierName', (c) => c.carrierName)],
      'MCC': [field('mobileCountryCode', (c) => c.mobileCountryCode)],
      'MNC': [field('mobileNetworkCode', (c) => c.mobileNetworkCode)],
      'SIM country': [field('isoCountryCode', (c) => c.isoCountryCode)],
      'VoIP allowed': [field('carrierAllowsVOIP', (c) => c.carrierAllowsVOIP)],
    };
  }
}

_Field _field<T extends Object>(
  String path,
  T? owner,
  Object? Function(T owner) read,
) => _Field(path, owner == null ? _missing : read(owner));

/// One field per entry of a legacy list, e.g. `telephonyInfo[1].radioType`.
List<_Field> _each<T extends Object>(
  String list,
  String name,
  List<T>? items,
  Object? Function(T item) read,
) {
  if (items == null || items.isEmpty) {
    return [_Field('$list[].$name', _missing)];
  }
  return [
    for (var i = 0; i < items.length; i++)
      _Field('$list[$i].$name', read(items[i])),
  ];
}

T? _at<T extends Object>(List<T>? items, int index) =>
    items != null && index < items.length ? items[index] : null;

// ---------------------------------------------------------------------------
// Formatting
// ---------------------------------------------------------------------------

String _format(Object? value) => switch (value) {
  _Missing() => 'no data',
  null => 'null',
  '' => '"" (empty)',
  final Enum e => e.name,
  final legacy.CellId cell => 'cid ${cell.cid}, lac ${cell.lac}',
  final List<Object?> list when list.isEmpty => '[] (empty)',
  final List<Object?> list => list.map(_format).join(', '),
  _ => '$value',
};

bool _isEmpty(Object? value) =>
    value == null || value == '' || (value is List && value.isEmpty);

String _markdownCell(List<_Field> fields) {
  if (fields.isEmpty) return '**not in API**';
  return fields
      .map((_Field f) => '`${f.path}`: ${_format(f.value)}')
      .join('<br>')
      .replaceAll('|', r'\|')
      .replaceAll('\n', ' ');
}

TextStyle? _valueStyle(ThemeData theme, Object? value) {
  final base = theme.textTheme.bodySmall;
  if (identical(value, _missing)) {
    return base?.copyWith(
      fontStyle: FontStyle.italic,
      color: theme.colorScheme.outline,
    );
  }
  if (_isEmpty(value)) {
    return base?.copyWith(
      fontStyle: FontStyle.italic,
      color: theme.colorScheme.tertiary,
    );
  }
  return base;
}

// ---------------------------------------------------------------------------
// Widgets
// ---------------------------------------------------------------------------

class _SummaryCard extends StatelessWidget {
  const _SummaryCard(this.comparison);

  final _Comparison comparison;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coverage = comparison.coverage;
    final permission = comparison.permission;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Platform: ${defaultTargetPlatform.name}'
              '${permission == null ? '' : ' · phone permission: ${permission.name}'}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            _CallStatus('carrier_info', comparison.legacyError),
            _CallStatus('carrier_info_plus', comparison.plusError),
            const SizedBox(height: 8),
            Text(
              '${coverage.shared} shared · ${coverage.legacyOnly} only in '
              'carrier_info · ${coverage.plusOnly} only in carrier_info_plus',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const _NotInApi(),
                Text('null / empty', style: _valueStyle(theme, null)),
                Text(
                  'no data (call failed or fewer SIMs)',
                  style: _valueStyle(theme, _missing),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CallStatus extends StatelessWidget {
  const _CallStatus(this.package, this.error);

  final String package;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    final failed = error != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            failed ? Icons.error_outline : Icons.check_circle_outline,
            size: 18,
            color: failed ? Theme.of(context).colorScheme.error : Colors.green,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              failed ? '$package failed: $error' : '$package read OK',
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable(this.rows);

  final List<_Row> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget header(String text) => Padding(
      padding: const EdgeInsets.all(6),
      child: Text(
        text,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    return Table(
      border: TableBorder.all(color: theme.colorScheme.outlineVariant),
      columnWidths: const {
        0: FlexColumnWidth(),
        1: FlexColumnWidth(1.4),
        2: FlexColumnWidth(1.4),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          children: [
            header('Field'),
            header('carrier_info'),
            header('carrier_info_plus'),
          ],
        ),
        for (final row in rows)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(6),
                child: Text(row.label, style: theme.textTheme.labelMedium),
              ),
              _ValueCell(row.legacyFields),
              _ValueCell(row.plusFields),
            ],
          ),
      ],
    );
  }
}

class _ValueCell extends StatelessWidget {
  const _ValueCell(this.fields);

  final List<_Field> fields;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pathStyle = TextStyle(
      fontFamily: 'monospace',
      fontFamilyFallback: const ['Menlo', 'Courier'],
      fontSize: 10,
      color: theme.colorScheme.onSurfaceVariant,
    );
    return Padding(
      padding: const EdgeInsets.all(6),
      child: fields.isEmpty
          ? const Align(alignment: Alignment.topLeft, child: _NotInApi())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (index, field) in fields.indexed) ...[
                  if (index > 0) const SizedBox(height: 6),
                  Text(
                    _format(field.value),
                    style: _valueStyle(theme, field.value),
                  ),
                  Text(field.path, style: pathStyle),
                ],
              ],
            ),
    );
  }
}

class _MarkdownPage extends StatelessWidget {
  const _MarkdownPage(this.markdown);

  final String markdown;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: markdown));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to the device clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Markdown'),
        actions: [
          IconButton(
            tooltip: 'Copy',
            icon: const Icon(Icons.copy_outlined),
            onPressed: () => _copy(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SelectableText(
          markdown,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontFamilyFallback: ['Menlo', 'Courier'],
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _NotInApi extends StatelessWidget {
  const _NotInApi();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text(
          'not in API',
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: scheme.onErrorContainer),
        ),
      ),
    );
  }
}
