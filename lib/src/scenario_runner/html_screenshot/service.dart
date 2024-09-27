import 'dart:convert';
import 'package:dev_studio_core/html_screenshot.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:quiver/collection.dart';

export 'package:dev_studio_core/html_screenshot.dart';

abstract class HtmlScreenshotService {
  Future<HtmlScreenshotResponse> htmlScreenshot(HtmlScreenshotRequest request);
  Future<PdfScreenshotResponse> pdfScreenshot(PdfScreenshotRequest request);
}

class RemoteHtmlScreenshotService implements HtmlScreenshotService {
  final Uri serverUri;

  RemoteHtmlScreenshotService(this.serverUri);

  @override
  Future<HtmlScreenshotResponse> htmlScreenshot(
      HtmlScreenshotRequest request) async {
    var response = await http.post(
        serverUri.replace(path: p.url.join(serverUri.path, 'html')),
        body: jsonEncode(request));
    if (response.statusCode >= 400) {
      throw Exception(
          'Html screenshot error: ${response.body} (${response.statusCode})');
    }
    var responseString = response.body;
    return HtmlScreenshotResponse.fromJson(
        jsonDecode(responseString) as Map<String, dynamic>);
  }

  @override
  Future<PdfScreenshotResponse> pdfScreenshot(
      PdfScreenshotRequest request) async {
    var response = await http.post(
        serverUri.replace(path: p.url.join(serverUri.path, 'pdf')),
        body: jsonEncode(request));
    if (response.statusCode >= 400) {
      throw Exception(
          'Html screenshot error: ${response.body} (${response.statusCode})');
    }
    var responseString = response.body;
    return PdfScreenshotResponse.fromJson(
        jsonDecode(responseString) as Map<String, dynamic>);
  }
}

class CachedHtmlScreenshotService implements HtmlScreenshotService {
  final HtmlScreenshotService innerService;
  final LruMap<HtmlScreenshotRequest, Future<HtmlScreenshotResponse>>
      _cacheHtml;
  final LruMap<PdfScreenshotRequest, Future<PdfScreenshotResponse>> _cachePdf;

  CachedHtmlScreenshotService(this.innerService, {required int maxSize})
      : _cacheHtml = LruMap(maximumSize: maxSize),
        _cachePdf = LruMap(maximumSize: maxSize);

  @override
  Future<HtmlScreenshotResponse> htmlScreenshot(HtmlScreenshotRequest request) {
    return _cacheHtml[request] ??= innerService.htmlScreenshot(request);
  }

  @override
  Future<PdfScreenshotResponse> pdfScreenshot(PdfScreenshotRequest request) {
    return _cachePdf[request] ??= innerService.pdfScreenshot(request);
  }
}
