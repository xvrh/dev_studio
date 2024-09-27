import 'dart:io';
import 'package:dev_studio/src/scenario_runner/html_screenshot/service.dart';

void main() async {
  var service = RemoteHtmlScreenshotService(
    Uri.https('lt100o5bki.execute-api.eu-central-1.amazonaws.com',
        'prod/html-screenshot/capture'),
    //Uri.parse(
    //    'https://aldbw1a08a.execute-api.eu-central-1.amazonaws.com/html-screenshot/capture'),
    //Uri.parse(
    //    'https://lt100o5bki.execute-api.eu-central-1.amazonaws.com/prod/html-screenshot/capture'),
  );
  var stopwatch = Stopwatch()..start();
  var response = await service.htmlScreenshot(
    HtmlScreenshotRequest(
        html: '<h1>Hello World</h1>', device: DeviceInfo.iphoneX),
  );
  print('${stopwatch.elapsed}');
  File('bin/_img1.png').writeAsBytesSync(response.image);
}
