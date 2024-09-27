import 'package:dev_studio_client/html_screenshot.dart' as screenshot;
import 'package:puppeteer/puppeteer.dart';
import 'service.dart';

class LocalHtmlScreenshotService implements HtmlScreenshotService {
  @override
  Future<HtmlScreenshotResponse> htmlScreenshot(
      HtmlScreenshotRequest request) async {
    // We launch a new browser for each request so we don't create zombie process
    // as we hot-start this tool.
    var browser = await puppeteer.launch(executablePath: BrowserPath.chrome);
    try {
      return await screenshot.htmlScreenshot(request, browser: browser);
    } finally {
      await browser.close();
    }
  }

  @override
  Future<screenshot.PdfScreenshotResponse> pdfScreenshot(
      screenshot.PdfScreenshotRequest request) {
    return screenshot.pdfScreenshot(request);
  }
}
