import 'package:dev_studio_core/html_screenshot.dart';
import 'package:image/image.dart' as img;
import 'package:logging/logging.dart';
import 'package:puppeteer/puppeteer.dart';

export 'package:dev_studio_core/html_screenshot.dart';

final _logger = Logger('html screenshot');

Future<HtmlScreenshotResponse> htmlScreenshot(HtmlScreenshotRequest request,
    {required Browser browser}) async {
  _logger.info('Screenshot html');
  var stopwatch = Stopwatch()..start();

  var page = await browser.newPage();
  try {
    await page.setViewport(DeviceViewport(
      width: request.device.width,
      height: request.device.height,
      deviceScaleFactor: request.device.pixelRatio,
      isMobile: true,
    ));
    await page.setContent(request.html, wait: Until.load);

    var screenshot =
        await page.screenshot(format: ScreenshotFormat.png, fullPage: true);
    var image = img.decodePng(screenshot)!;

    var texts = <TextInfo>[];
    for (var element in await page.$$('[$translationKeyHtmlAttribute]')) {
      var key = await page.evaluate(
          "e => e.getAttribute('$translationKeyHtmlAttribute')",
          args: [element]);
      var translationKey = key as String;
      if (translationKey.isNotEmpty) {
        var box = (await element.boundingBox)!;
        texts.add(TextInfo(translationKey,
            rectangle:
                Rect.fromRectangle(box, pixelRatio: request.device.pixelRatio),
            text: await page.evaluate('e => e.textContent', args: [element])));
      }
    }

    var links = <LinkInfo>[];
    for (var link in await page.$$('a')) {
      var href =
          await page.evaluate("e => e.getAttribute('href')", args: [link]);
      var box = (await link.boundingBox)!;
      links.add(LinkInfo(href as String,
          rectangle:
              Rect.fromRectangle(box, pixelRatio: request.device.pixelRatio),
          text: await page.evaluate('e => e.textContent', args: [link])));
    }

    _logger.info('Screenshot in ${stopwatch.elapsed}');

    return HtmlScreenshotResponse(
      image: screenshot,
      imageWidth: image.width.round(),
      imageHeight: image.height.round(),
      texts: texts,
      links: links,
    );
  } finally {
    await page.close();
  }
}
