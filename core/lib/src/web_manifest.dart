import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'web_manifest.g.dart';

@JsonSerializable()
class WebManifest {
  final Map<String, ManifestEntry> versions;
  String latest;

  WebManifest(this.versions, {required this.latest});

  factory WebManifest.fromJson(Map<String, dynamic> json) =>
      _$WebManifestFromJson(json);

  Map<String, dynamic> toJson() => _$WebManifestToJson(this);
}

@JsonSerializable()
class ManifestEntry {
  final String buildNumber;
  final DateTime date;
  final String version;
  final String url;

  ManifestEntry({
    required this.buildNumber,
    required this.version,
    required this.date,
    required this.url,
  });

  factory ManifestEntry.fromJson(Map<String, dynamic> json) =>
      _$ManifestEntryFromJson(json);

  Map<String, dynamic> toJson() => _$ManifestEntryToJson(this);

  String get description =>
      '$version (${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')})';
}

@JsonSerializable()
class BuildInfo {
  final ManifestEntry version;
  final List<RelatedProject> relatedProjects;
  final String? manifestPath;

  BuildInfo(
    this.version, {
    required this.relatedProjects,
    required this.manifestPath,
  });

  factory BuildInfo.fromJson(Map<String, dynamic> json) =>
      _$BuildInfoFromJson(json);

  Map<String, dynamic> toJson() => _$BuildInfoToJson(this);

  String toHtmlAttribute() =>
      HtmlEscape(HtmlEscapeMode.attribute).convert(jsonEncode(this));
}

@JsonSerializable()
class RelatedProject {
  final String name;
  final String url;

  RelatedProject(this.name, {required this.url});

  factory RelatedProject.fromJson(Map<String, dynamic> json) =>
      _$RelatedProjectFromJson(json);

  Map<String, dynamic> toJson() => _$RelatedProjectToJson(this);
}
