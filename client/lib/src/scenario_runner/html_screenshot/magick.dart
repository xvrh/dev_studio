import 'dart:convert';
import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:process_runner/process_runner.dart';
import '../../../html_screenshot.dart';

Future<PdfScreenshotResponse> pdfScreenshot(
    PdfScreenshotRequest request) async {
  var processRunner = ProcessRunner();

  var result = await processRunner.runProcess([
    'magick',
    'convert',
    '-resize',
    '${request.device.width}x${request.device.height}',
    '-',
    'png:-'
  ], stdin: Stream.value(base64Decode(request.base64Bytes)));

  var bytes = Uint8List.fromList(result.stdoutRaw);
  var image = decodePng(bytes)!;
  return PdfScreenshotResponse(
      image: bytes, imageWidth: image.width, imageHeight: image.height);
}
