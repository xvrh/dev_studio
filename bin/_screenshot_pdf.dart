import 'dart:convert';
import 'dart:io';
import 'package:dev_studio_client/html_screenshot.dart';
import 'package:logging/logging.dart';

void main() async {
  Logger.root
    ..level = Level.ALL
    ..onRecord.listen(print);

  var response = await pdfScreenshot(PdfScreenshotRequest(
    base64Bytes: base64Encode(
        File('/Users/xavier/Downloads/034923801386.pdf').readAsBytesSync()),
    device: DeviceInfo.iphoneX,
  ));

  File('bin/_img_pdf.png').writeAsBytesSync(response.image);
}
