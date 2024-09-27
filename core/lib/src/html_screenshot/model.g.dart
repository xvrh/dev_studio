// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HtmlScreenshotRequest _$HtmlScreenshotRequestFromJson(
        Map<String, dynamic> json) =>
    HtmlScreenshotRequest(
      html: json['html'] as String,
      device: DeviceInfo.fromJson(json['device'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HtmlScreenshotRequestToJson(
        HtmlScreenshotRequest instance) =>
    <String, dynamic>{
      'html': instance.html,
      'device': instance.device,
    };

HtmlScreenshotResponse _$HtmlScreenshotResponseFromJson(
        Map<String, dynamic> json) =>
    HtmlScreenshotResponse(
      image: base64Decode(json['image'] as String),
      imageWidth: json['imageWidth'] as int,
      imageHeight: json['imageHeight'] as int,
      texts: (json['texts'] as List<dynamic>)
          .map((e) => TextInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      links: (json['links'] as List<dynamic>)
          .map((e) => LinkInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HtmlScreenshotResponseToJson(
        HtmlScreenshotResponse instance) =>
    <String, dynamic>{
      'image': base64Encode(instance.image),
      'imageWidth': instance.imageWidth,
      'imageHeight': instance.imageHeight,
      'texts': instance.texts,
      'links': instance.links,
    };

PdfScreenshotRequest _$PdfScreenshotRequestFromJson(
        Map<String, dynamic> json) =>
    PdfScreenshotRequest(
      base64Bytes: json['base64Bytes'] as String,
      device: DeviceInfo.fromJson(json['device'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PdfScreenshotRequestToJson(
        PdfScreenshotRequest instance) =>
    <String, dynamic>{
      'base64Bytes': instance.base64Bytes,
      'device': instance.device,
    };

PdfScreenshotResponse _$PdfScreenshotResponseFromJson(
        Map<String, dynamic> json) =>
    PdfScreenshotResponse(
      image: base64Decode(json['image'] as String),
      imageWidth: json['imageWidth'] as int,
      imageHeight: json['imageHeight'] as int,
    );

Map<String, dynamic> _$PdfScreenshotResponseToJson(
        PdfScreenshotResponse instance) =>
    <String, dynamic>{
      'image': base64Encode(instance.image),
      'imageWidth': instance.imageWidth,
      'imageHeight': instance.imageHeight,
    };

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => DeviceInfo(
      width: json['width'] as int,
      height: json['height'] as int,
      pixelRatio: json['pixelRatio'] as num,
    );

Map<String, dynamic> _$DeviceInfoToJson(DeviceInfo instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'pixelRatio': instance.pixelRatio,
    };

TextInfo _$TextInfoFromJson(Map<String, dynamic> json) => TextInfo(
      json['translationKey'] as String,
      text: json['text'] as String,
      rectangle: Rect.fromJson(json['rectangle'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TextInfoToJson(TextInfo instance) => <String, dynamic>{
      'translationKey': instance.translationKey,
      'rectangle': instance.rectangle,
      'text': instance.text,
    };

LinkInfo _$LinkInfoFromJson(Map<String, dynamic> json) => LinkInfo(
      json['href'] as String,
      text: json['text'] as String,
      rectangle: Rect.fromJson(json['rectangle'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LinkInfoToJson(LinkInfo instance) => <String, dynamic>{
      'href': instance.href,
      'rectangle': instance.rectangle,
      'text': instance.text,
    };

Rect _$RectFromJson(Map<String, dynamic> json) => Rect(
      json['x'] as num,
      json['y'] as num,
      json['width'] as num,
      json['height'] as num,
    );

Map<String, dynamic> _$RectToJson(Rect instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'width': instance.width,
      'height': instance.height,
    };
