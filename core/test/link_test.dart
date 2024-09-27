import 'package:dev_studio_core/link_generator.dart';
import 'package:test/test.dart';

void main() {
  test('Scenario test', () {
    var url = scenarioLink('https://baseurl.com/page.html')(
        ['Ho me', 'Login'], '1-2-3');
    expect(
      url,
      Uri.parse(
          'https://baseurl.com/page.html#/scenario/Ho%20me%2FLogin/detail/1-2-3'),
    );
  });
}
