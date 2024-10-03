// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ProjectInfo> _$projectInfoSerializer = new _$ProjectInfoSerializer();
Serializer<ConfluenceInfo> _$confluenceInfoSerializer =
    new _$ConfluenceInfoSerializer();
Serializer<FirebaseInfo> _$firebaseInfoSerializer =
    new _$FirebaseInfoSerializer();

class _$ProjectInfoSerializer implements StructuredSerializer<ProjectInfo> {
  @override
  final Iterable<Type> types = const [ProjectInfo, _$ProjectInfo];
  @override
  final String wireName = 'ProjectInfo';

  @override
  Iterable<Object?> serialize(Serializers serializers, ProjectInfo object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'currentDirectory',
      serializers.serialize(object.currentDirectory,
          specifiedType: const FullType(String)),
      'supportedLanguages',
      serializers.serialize(object.supportedLanguages,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];
    Object? value;
    value = object.rootPath;
    if (value != null) {
      result
        ..add('rootPath')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.defaultStatusBarBrightness;
    if (value != null) {
      result
        ..add('defaultStatusBarBrightness')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.poEditorProjectId;
    if (value != null) {
      result
        ..add('poEditorProjectId')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.confluence;
    if (value != null) {
      result
        ..add('confluence')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(ConfluenceInfo)));
    }
    value = object.firebase;
    if (value != null) {
      result
        ..add('firebase')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(FirebaseInfo)));
    }
    return result;
  }

  @override
  ProjectInfo deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProjectInfoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'rootPath':
          result.rootPath = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'currentDirectory':
          result.currentDirectory = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'supportedLanguages':
          result.supportedLanguages.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'defaultStatusBarBrightness':
          result.defaultStatusBarBrightness = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'poEditorProjectId':
          result.poEditorProjectId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'confluence':
          result.confluence.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ConfluenceInfo))!
              as ConfluenceInfo);
          break;
        case 'firebase':
          result.firebase.replace(serializers.deserialize(value,
              specifiedType: const FullType(FirebaseInfo))! as FirebaseInfo);
          break;
      }
    }

    return result.build();
  }
}

class _$ConfluenceInfoSerializer
    implements StructuredSerializer<ConfluenceInfo> {
  @override
  final Iterable<Type> types = const [ConfluenceInfo, _$ConfluenceInfo];
  @override
  final String wireName = 'ConfluenceInfo';

  @override
  Iterable<Object?> serialize(Serializers serializers, ConfluenceInfo object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'site',
      serializers.serialize(object.site, specifiedType: const FullType(String)),
      'space',
      serializers.serialize(object.space,
          specifiedType: const FullType(String)),
      'docPrefix',
      serializers.serialize(object.docPrefix,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ConfluenceInfo deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ConfluenceInfoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'site':
          result.site = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'space':
          result.space = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'docPrefix':
          result.docPrefix = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$FirebaseInfoSerializer implements StructuredSerializer<FirebaseInfo> {
  @override
  final Iterable<Type> types = const [FirebaseInfo, _$FirebaseInfo];
  @override
  final String wireName = 'FirebaseInfo';

  @override
  Iterable<Object?> serialize(Serializers serializers, FirebaseInfo object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'projectId',
      serializers.serialize(object.projectId,
          specifiedType: const FullType(String)),
      'androidAppId',
      serializers.serialize(object.androidAppId,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  FirebaseInfo deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FirebaseInfoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'projectId':
          result.projectId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'androidAppId':
          result.androidAppId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ProjectInfo extends ProjectInfo {
  @override
  final String name;
  @override
  final String? rootPath;
  @override
  final String currentDirectory;
  @override
  final BuiltList<String> supportedLanguages;
  @override
  final int? defaultStatusBarBrightness;
  @override
  final int? poEditorProjectId;
  @override
  final ConfluenceInfo? confluence;
  @override
  final FirebaseInfo? firebase;

  factory _$ProjectInfo([void Function(ProjectInfoBuilder)? updates]) =>
      (new ProjectInfoBuilder()..update(updates))._build();

  _$ProjectInfo._(
      {required this.name,
      this.rootPath,
      required this.currentDirectory,
      required this.supportedLanguages,
      this.defaultStatusBarBrightness,
      this.poEditorProjectId,
      this.confluence,
      this.firebase})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(name, r'ProjectInfo', 'name');
    BuiltValueNullFieldError.checkNotNull(
        currentDirectory, r'ProjectInfo', 'currentDirectory');
    BuiltValueNullFieldError.checkNotNull(
        supportedLanguages, r'ProjectInfo', 'supportedLanguages');
  }

  @override
  ProjectInfo rebuild(void Function(ProjectInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectInfoBuilder toBuilder() => new ProjectInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectInfo &&
        name == other.name &&
        rootPath == other.rootPath &&
        currentDirectory == other.currentDirectory &&
        supportedLanguages == other.supportedLanguages &&
        defaultStatusBarBrightness == other.defaultStatusBarBrightness &&
        poEditorProjectId == other.poEditorProjectId &&
        confluence == other.confluence &&
        firebase == other.firebase;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, rootPath.hashCode);
    _$hash = $jc(_$hash, currentDirectory.hashCode);
    _$hash = $jc(_$hash, supportedLanguages.hashCode);
    _$hash = $jc(_$hash, defaultStatusBarBrightness.hashCode);
    _$hash = $jc(_$hash, poEditorProjectId.hashCode);
    _$hash = $jc(_$hash, confluence.hashCode);
    _$hash = $jc(_$hash, firebase.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectInfo')
          ..add('name', name)
          ..add('rootPath', rootPath)
          ..add('currentDirectory', currentDirectory)
          ..add('supportedLanguages', supportedLanguages)
          ..add('defaultStatusBarBrightness', defaultStatusBarBrightness)
          ..add('poEditorProjectId', poEditorProjectId)
          ..add('confluence', confluence)
          ..add('firebase', firebase))
        .toString();
  }
}

class ProjectInfoBuilder implements Builder<ProjectInfo, ProjectInfoBuilder> {
  _$ProjectInfo? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _rootPath;
  String? get rootPath => _$this._rootPath;
  set rootPath(String? rootPath) => _$this._rootPath = rootPath;

  String? _currentDirectory;
  String? get currentDirectory => _$this._currentDirectory;
  set currentDirectory(String? currentDirectory) =>
      _$this._currentDirectory = currentDirectory;

  ListBuilder<String>? _supportedLanguages;
  ListBuilder<String> get supportedLanguages =>
      _$this._supportedLanguages ??= new ListBuilder<String>();
  set supportedLanguages(ListBuilder<String>? supportedLanguages) =>
      _$this._supportedLanguages = supportedLanguages;

  int? _defaultStatusBarBrightness;
  int? get defaultStatusBarBrightness => _$this._defaultStatusBarBrightness;
  set defaultStatusBarBrightness(int? defaultStatusBarBrightness) =>
      _$this._defaultStatusBarBrightness = defaultStatusBarBrightness;

  int? _poEditorProjectId;
  int? get poEditorProjectId => _$this._poEditorProjectId;
  set poEditorProjectId(int? poEditorProjectId) =>
      _$this._poEditorProjectId = poEditorProjectId;

  ConfluenceInfoBuilder? _confluence;
  ConfluenceInfoBuilder get confluence =>
      _$this._confluence ??= new ConfluenceInfoBuilder();
  set confluence(ConfluenceInfoBuilder? confluence) =>
      _$this._confluence = confluence;

  FirebaseInfoBuilder? _firebase;
  FirebaseInfoBuilder get firebase =>
      _$this._firebase ??= new FirebaseInfoBuilder();
  set firebase(FirebaseInfoBuilder? firebase) => _$this._firebase = firebase;

  ProjectInfoBuilder();

  ProjectInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _rootPath = $v.rootPath;
      _currentDirectory = $v.currentDirectory;
      _supportedLanguages = $v.supportedLanguages.toBuilder();
      _defaultStatusBarBrightness = $v.defaultStatusBarBrightness;
      _poEditorProjectId = $v.poEditorProjectId;
      _confluence = $v.confluence?.toBuilder();
      _firebase = $v.firebase?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectInfo other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProjectInfo;
  }

  @override
  void update(void Function(ProjectInfoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectInfo build() => _build();

  _$ProjectInfo _build() {
    _$ProjectInfo _$result;
    try {
      _$result = _$v ??
          new _$ProjectInfo._(
              name: BuiltValueNullFieldError.checkNotNull(
                  name, r'ProjectInfo', 'name'),
              rootPath: rootPath,
              currentDirectory: BuiltValueNullFieldError.checkNotNull(
                  currentDirectory, r'ProjectInfo', 'currentDirectory'),
              supportedLanguages: supportedLanguages.build(),
              defaultStatusBarBrightness: defaultStatusBarBrightness,
              poEditorProjectId: poEditorProjectId,
              confluence: _confluence?.build(),
              firebase: _firebase?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'supportedLanguages';
        supportedLanguages.build();

        _$failedField = 'confluence';
        _confluence?.build();
        _$failedField = 'firebase';
        _firebase?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ProjectInfo', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ConfluenceInfo extends ConfluenceInfo {
  @override
  final String site;
  @override
  final String space;
  @override
  final String docPrefix;

  factory _$ConfluenceInfo([void Function(ConfluenceInfoBuilder)? updates]) =>
      (new ConfluenceInfoBuilder()..update(updates))._build();

  _$ConfluenceInfo._(
      {required this.site, required this.space, required this.docPrefix})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(site, r'ConfluenceInfo', 'site');
    BuiltValueNullFieldError.checkNotNull(space, r'ConfluenceInfo', 'space');
    BuiltValueNullFieldError.checkNotNull(
        docPrefix, r'ConfluenceInfo', 'docPrefix');
  }

  @override
  ConfluenceInfo rebuild(void Function(ConfluenceInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConfluenceInfoBuilder toBuilder() =>
      new ConfluenceInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConfluenceInfo &&
        site == other.site &&
        space == other.space &&
        docPrefix == other.docPrefix;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, site.hashCode);
    _$hash = $jc(_$hash, space.hashCode);
    _$hash = $jc(_$hash, docPrefix.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConfluenceInfo')
          ..add('site', site)
          ..add('space', space)
          ..add('docPrefix', docPrefix))
        .toString();
  }
}

class ConfluenceInfoBuilder
    implements Builder<ConfluenceInfo, ConfluenceInfoBuilder> {
  _$ConfluenceInfo? _$v;

  String? _site;
  String? get site => _$this._site;
  set site(String? site) => _$this._site = site;

  String? _space;
  String? get space => _$this._space;
  set space(String? space) => _$this._space = space;

  String? _docPrefix;
  String? get docPrefix => _$this._docPrefix;
  set docPrefix(String? docPrefix) => _$this._docPrefix = docPrefix;

  ConfluenceInfoBuilder();

  ConfluenceInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _site = $v.site;
      _space = $v.space;
      _docPrefix = $v.docPrefix;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConfluenceInfo other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ConfluenceInfo;
  }

  @override
  void update(void Function(ConfluenceInfoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConfluenceInfo build() => _build();

  _$ConfluenceInfo _build() {
    final _$result = _$v ??
        new _$ConfluenceInfo._(
            site: BuiltValueNullFieldError.checkNotNull(
                site, r'ConfluenceInfo', 'site'),
            space: BuiltValueNullFieldError.checkNotNull(
                space, r'ConfluenceInfo', 'space'),
            docPrefix: BuiltValueNullFieldError.checkNotNull(
                docPrefix, r'ConfluenceInfo', 'docPrefix'));
    replace(_$result);
    return _$result;
  }
}

class _$FirebaseInfo extends FirebaseInfo {
  @override
  final String projectId;
  @override
  final String androidAppId;

  factory _$FirebaseInfo([void Function(FirebaseInfoBuilder)? updates]) =>
      (new FirebaseInfoBuilder()..update(updates))._build();

  _$FirebaseInfo._({required this.projectId, required this.androidAppId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        projectId, r'FirebaseInfo', 'projectId');
    BuiltValueNullFieldError.checkNotNull(
        androidAppId, r'FirebaseInfo', 'androidAppId');
  }

  @override
  FirebaseInfo rebuild(void Function(FirebaseInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FirebaseInfoBuilder toBuilder() => new FirebaseInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FirebaseInfo &&
        projectId == other.projectId &&
        androidAppId == other.androidAppId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, projectId.hashCode);
    _$hash = $jc(_$hash, androidAppId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FirebaseInfo')
          ..add('projectId', projectId)
          ..add('androidAppId', androidAppId))
        .toString();
  }
}

class FirebaseInfoBuilder
    implements Builder<FirebaseInfo, FirebaseInfoBuilder> {
  _$FirebaseInfo? _$v;

  String? _projectId;
  String? get projectId => _$this._projectId;
  set projectId(String? projectId) => _$this._projectId = projectId;

  String? _androidAppId;
  String? get androidAppId => _$this._androidAppId;
  set androidAppId(String? androidAppId) => _$this._androidAppId = androidAppId;

  FirebaseInfoBuilder();

  FirebaseInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _projectId = $v.projectId;
      _androidAppId = $v.androidAppId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FirebaseInfo other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FirebaseInfo;
  }

  @override
  void update(void Function(FirebaseInfoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FirebaseInfo build() => _build();

  _$FirebaseInfo _build() {
    final _$result = _$v ??
        new _$FirebaseInfo._(
            projectId: BuiltValueNullFieldError.checkNotNull(
                projectId, r'FirebaseInfo', 'projectId'),
            androidAppId: BuiltValueNullFieldError.checkNotNull(
                androidAppId, r'FirebaseInfo', 'androidAppId'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
