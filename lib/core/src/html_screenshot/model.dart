import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';
import '../scenario/model/rectangle.dart' as model show Rectangle;
import '../scenario/model/screen.dart' as model show TextInfo;

part 'model.g.dart';

@JsonSerializable()
class HtmlScreenshotRequest {
  final String html;
  final DeviceInfo device;

  HtmlScreenshotRequest({
    required this.html,
    required this.device,
  });

  factory HtmlScreenshotRequest.fromJson(Map<String, dynamic> json) =>
      _$HtmlScreenshotRequestFromJson(json);

  Map<String, dynamic> toJson() => _$HtmlScreenshotRequestToJson(this);

  @override
  bool operator ==(other) =>
      other is HtmlScreenshotRequest &&
      other.html == html &&
      other.device == device;

  @override
  int get hashCode => Object.hash(html, device);
}

@JsonSerializable()
class HtmlScreenshotResponse {
  @JsonKey(fromJson: base64Decode, toJson: base64Encode)
  final Uint8List image;
  final int imageWidth;
  final int imageHeight;
  final List<TextInfo> texts;
  final List<LinkInfo> links;

  HtmlScreenshotResponse({
    required this.image,
    required this.imageWidth,
    required this.imageHeight,
    required this.texts,
    required this.links,
  });

  factory HtmlScreenshotResponse.fromJson(Map<String, dynamic> json) =>
      _$HtmlScreenshotResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HtmlScreenshotResponseToJson(this);
}

@JsonSerializable()
class PdfScreenshotRequest {
  final String base64Bytes;
  final DeviceInfo device;

  PdfScreenshotRequest({
    required this.base64Bytes,
    required this.device,
  });

  factory PdfScreenshotRequest.fromJson(Map<String, dynamic> json) =>
      _$PdfScreenshotRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PdfScreenshotRequestToJson(this);

  @override
  bool operator ==(other) =>
      other is PdfScreenshotRequest &&
      other.base64Bytes == base64Bytes &&
      other.device == device;

  @override
  int get hashCode => Object.hash(base64Bytes, device);
}

@JsonSerializable()
class PdfScreenshotResponse {
  @JsonKey(fromJson: base64Decode, toJson: base64Encode)
  final Uint8List image;
  final int imageWidth;
  final int imageHeight;

  PdfScreenshotResponse({
    required this.image,
    required this.imageWidth,
    required this.imageHeight,
  });

  factory PdfScreenshotResponse.fromJson(Map<String, dynamic> json) =>
      _$PdfScreenshotResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PdfScreenshotResponseToJson(this);
}

@JsonSerializable()
class DeviceInfo {
  static final iphoneX = DeviceInfo(
    width: 375,
    height: 812,
    pixelRatio: 3,
  );

  final int width;
  final int height;
  final num pixelRatio;

  DeviceInfo({
    required this.width,
    required this.height,
    required this.pixelRatio,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);

  @override
  bool operator ==(other) =>
      other is DeviceInfo &&
      other.width == width &&
      other.height == height &&
      other.pixelRatio == pixelRatio;

  @override
  int get hashCode => Object.hash(width, height, pixelRatio);
}

@JsonSerializable()
class TextInfo {
  final String translationKey;
  final Rect rectangle;
  final String text;

  TextInfo(this.translationKey, {required this.text, required this.rectangle});

  factory TextInfo.fromJson(Map<String, dynamic> json) =>
      _$TextInfoFromJson(json);

  Map<String, dynamic> toJson() => _$TextInfoToJson(this);

  @override
  String toString() => 'TextInfo($translationKey, $rectangle, $text)';

  model.TextInfo toTextInfo() => model.TextInfo(
        text: text,
        translationKey: translationKey,
        rawTranslation: text,
        globalRectangle: model.Rectangle.fromTLWH(
          rectangle.y.toDouble(),
          rectangle.x.toDouble(),
          rectangle.width.toDouble(),
          rectangle.height.toDouble(),
        ),
      );
}

@JsonSerializable()
class LinkInfo {
  final String href;
  final Rect rectangle;
  final String text;

  LinkInfo(this.href, {required this.text, required this.rectangle});

  factory LinkInfo.fromJson(Map<String, dynamic> json) =>
      _$LinkInfoFromJson(json);

  Map<String, dynamic> toJson() => _$LinkInfoToJson(this);

  @override
  String toString() => 'LinkInfo($href, $rectangle, $text)';
}

@JsonSerializable()
class Rect {
  final num x;
  final num y;
  final num width;
  final num height;

  Rect(this.x, this.y, this.width, this.height);

  factory Rect.fromRectangle(Rectangle box, {required num pixelRatio}) => Rect(
      box.left * pixelRatio,
      box.top * pixelRatio,
      box.width * pixelRatio,
      box.height * pixelRatio);

  factory Rect.fromJson(Map<String, dynamic> json) => _$RectFromJson(json);

  Map<String, dynamic> toJson() => _$RectToJson(this);

  @override
  String toString() => 'Rect($x, $y, $width, $height)';
}
