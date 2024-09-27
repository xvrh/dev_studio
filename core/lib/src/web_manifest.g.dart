// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_manifest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebManifest _$WebManifestFromJson(Map<String, dynamic> json) => WebManifest(
      (json['versions'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, ManifestEntry.fromJson(e as Map<String, dynamic>)),
      ),
      latest: json['latest'] as String,
    );

Map<String, dynamic> _$WebManifestToJson(WebManifest instance) =>
    <String, dynamic>{
      'versions': instance.versions,
      'latest': instance.latest,
    };

ManifestEntry _$ManifestEntryFromJson(Map<String, dynamic> json) =>
    ManifestEntry(
      buildNumber: json['buildNumber'] as String,
      version: json['version'] as String,
      date: DateTime.parse(json['date'] as String),
      url: json['url'] as String,
    );

Map<String, dynamic> _$ManifestEntryToJson(ManifestEntry instance) =>
    <String, dynamic>{
      'buildNumber': instance.buildNumber,
      'date': instance.date.toIso8601String(),
      'version': instance.version,
      'url': instance.url,
    };

BuildInfo _$BuildInfoFromJson(Map<String, dynamic> json) => BuildInfo(
      ManifestEntry.fromJson(json['version'] as Map<String, dynamic>),
      relatedProjects: (json['relatedProjects'] as List<dynamic>)
          .map((e) => RelatedProject.fromJson(e as Map<String, dynamic>))
          .toList(),
      manifestPath: json['manifestPath'] as String?,
    );

Map<String, dynamic> _$BuildInfoToJson(BuildInfo instance) => <String, dynamic>{
      'version': instance.version,
      'relatedProjects': instance.relatedProjects,
      'manifestPath': instance.manifestPath,
    };

RelatedProject _$RelatedProjectFromJson(Map<String, dynamic> json) =>
    RelatedProject(
      json['name'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$RelatedProjectToJson(RelatedProject instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
    };
