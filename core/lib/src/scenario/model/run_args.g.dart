// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run_args.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<RunArgs> _$runArgsSerializer = new _$RunArgsSerializer();

class _$RunArgsSerializer implements StructuredSerializer<RunArgs> {
  @override
  final Iterable<Type> types = const [RunArgs, _$RunArgs];
  @override
  final String wireName = 'RunArgs';

  @override
  Iterable<Object?> serialize(Serializers serializers, RunArgs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'scenarioName',
      serializers.serialize(object.scenarioName,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'device',
      serializers.serialize(object.device,
          specifiedType: const FullType(DeviceInfo)),
      'accessibility',
      serializers.serialize(object.accessibility,
          specifiedType: const FullType(AccessibilityConfig)),
      'imageRatio',
      serializers.serialize(object.imageRatio,
          specifiedType: const FullType(double)),
      'language',
      serializers.serialize(object.language,
          specifiedType: const FullType(String)),
      'onlyWithDocumentationKey',
      serializers.serialize(object.onlyWithDocumentationKey,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  RunArgs deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RunArgsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'scenarioName':
          result.scenarioName.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'device':
          result.device.replace(serializers.deserialize(value,
              specifiedType: const FullType(DeviceInfo))! as DeviceInfo);
          break;
        case 'accessibility':
          result.accessibility.replace(serializers.deserialize(value,
                  specifiedType: const FullType(AccessibilityConfig))!
              as AccessibilityConfig);
          break;
        case 'imageRatio':
          result.imageRatio = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'language':
          result.language = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'onlyWithDocumentationKey':
          result.onlyWithDocumentationKey = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$RunArgs extends RunArgs {
  @override
  final int id;
  @override
  final BuiltList<String> scenarioName;
  @override
  final DeviceInfo device;
  @override
  final AccessibilityConfig accessibility;
  @override
  final double imageRatio;
  @override
  final String language;
  @override
  final bool onlyWithDocumentationKey;

  factory _$RunArgs([void Function(RunArgsBuilder)? updates]) =>
      (new RunArgsBuilder()..update(updates))._build();

  _$RunArgs._(
      {required this.id,
      required this.scenarioName,
      required this.device,
      required this.accessibility,
      required this.imageRatio,
      required this.language,
      required this.onlyWithDocumentationKey})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'RunArgs', 'id');
    BuiltValueNullFieldError.checkNotNull(
        scenarioName, r'RunArgs', 'scenarioName');
    BuiltValueNullFieldError.checkNotNull(device, r'RunArgs', 'device');
    BuiltValueNullFieldError.checkNotNull(
        accessibility, r'RunArgs', 'accessibility');
    BuiltValueNullFieldError.checkNotNull(imageRatio, r'RunArgs', 'imageRatio');
    BuiltValueNullFieldError.checkNotNull(language, r'RunArgs', 'language');
    BuiltValueNullFieldError.checkNotNull(
        onlyWithDocumentationKey, r'RunArgs', 'onlyWithDocumentationKey');
  }

  @override
  RunArgs rebuild(void Function(RunArgsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RunArgsBuilder toBuilder() => new RunArgsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RunArgs &&
        id == other.id &&
        scenarioName == other.scenarioName &&
        device == other.device &&
        accessibility == other.accessibility &&
        imageRatio == other.imageRatio &&
        language == other.language &&
        onlyWithDocumentationKey == other.onlyWithDocumentationKey;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, scenarioName.hashCode);
    _$hash = $jc(_$hash, device.hashCode);
    _$hash = $jc(_$hash, accessibility.hashCode);
    _$hash = $jc(_$hash, imageRatio.hashCode);
    _$hash = $jc(_$hash, language.hashCode);
    _$hash = $jc(_$hash, onlyWithDocumentationKey.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RunArgs')
          ..add('id', id)
          ..add('scenarioName', scenarioName)
          ..add('device', device)
          ..add('accessibility', accessibility)
          ..add('imageRatio', imageRatio)
          ..add('language', language)
          ..add('onlyWithDocumentationKey', onlyWithDocumentationKey))
        .toString();
  }
}

class RunArgsBuilder implements Builder<RunArgs, RunArgsBuilder> {
  _$RunArgs? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  ListBuilder<String>? _scenarioName;
  ListBuilder<String> get scenarioName =>
      _$this._scenarioName ??= new ListBuilder<String>();
  set scenarioName(ListBuilder<String>? scenarioName) =>
      _$this._scenarioName = scenarioName;

  DeviceInfoBuilder? _device;
  DeviceInfoBuilder get device => _$this._device ??= new DeviceInfoBuilder();
  set device(DeviceInfoBuilder? device) => _$this._device = device;

  AccessibilityConfigBuilder? _accessibility;
  AccessibilityConfigBuilder get accessibility =>
      _$this._accessibility ??= new AccessibilityConfigBuilder();
  set accessibility(AccessibilityConfigBuilder? accessibility) =>
      _$this._accessibility = accessibility;

  double? _imageRatio;
  double? get imageRatio => _$this._imageRatio;
  set imageRatio(double? imageRatio) => _$this._imageRatio = imageRatio;

  String? _language;
  String? get language => _$this._language;
  set language(String? language) => _$this._language = language;

  bool? _onlyWithDocumentationKey;
  bool? get onlyWithDocumentationKey => _$this._onlyWithDocumentationKey;
  set onlyWithDocumentationKey(bool? onlyWithDocumentationKey) =>
      _$this._onlyWithDocumentationKey = onlyWithDocumentationKey;

  RunArgsBuilder();

  RunArgsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _scenarioName = $v.scenarioName.toBuilder();
      _device = $v.device.toBuilder();
      _accessibility = $v.accessibility.toBuilder();
      _imageRatio = $v.imageRatio;
      _language = $v.language;
      _onlyWithDocumentationKey = $v.onlyWithDocumentationKey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RunArgs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RunArgs;
  }

  @override
  void update(void Function(RunArgsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RunArgs build() => _build();

  _$RunArgs _build() {
    _$RunArgs _$result;
    try {
      _$result = _$v ??
          new _$RunArgs._(
              id: BuiltValueNullFieldError.checkNotNull(id, r'RunArgs', 'id'),
              scenarioName: scenarioName.build(),
              device: device.build(),
              accessibility: accessibility.build(),
              imageRatio: BuiltValueNullFieldError.checkNotNull(
                  imageRatio, r'RunArgs', 'imageRatio'),
              language: BuiltValueNullFieldError.checkNotNull(
                  language, r'RunArgs', 'language'),
              onlyWithDocumentationKey: BuiltValueNullFieldError.checkNotNull(
                  onlyWithDocumentationKey,
                  r'RunArgs',
                  'onlyWithDocumentationKey'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scenarioName';
        scenarioName.build();
        _$failedField = 'device';
        device.build();
        _$failedField = 'accessibility';
        accessibility.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'RunArgs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
