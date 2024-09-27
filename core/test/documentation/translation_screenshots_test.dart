import 'package:dart_style/dart_style.dart';
import 'package:dev_studio_core/src/documentation/translation_screenshots.dart';
import 'package:test/test.dart';

void main() {
  test('Parse translation screenshots code', () {
    var result = TranslationScreenshotUtilities.parseFiltersCode('''
import 'translations_screenshots.gen.dart';

final screenshots = screenshotsForTranslations(
  accountLogoutButton: {AccountLogoutButton.accountPreferencesAccount},
  accountTitle: {AccountTitle.accountPreferencesAccount},
  accountVersion: {AccountVersion.accountPreferencesAccount, AccountVersion.accountPreferencesOther},
  mfaTitleStepXOfTotal: {MfaTitleStepXOfTotal.accountProfile2FA}
);
''');

    expect(result, {
      'accountLogoutButton': ['accountPreferencesAccount'],
      'accountTitle': ['accountPreferencesAccount'],
      'accountVersion': [
        'accountPreferencesAccount',
        'accountPreferencesOther'
      ],
      'mfaTitleStepXOfTotal': ['accountProfile2FA'],
    });
  });

  test('Generate screenshot filter code', () {
    var code = TranslationScreenshotUtilities.generateFiltersCode({
      'accountLogoutButton': ['account/Preference_Account', 'Other Code'],
      'accountTitle': ['Account/Preference Account'],
    });
    expect(code, DartFormatter().format('''
import 'translations_screenshots.gen.dart';

final screenshots = screenshotsForTranslations(
  accountLogoutButton: {AccountLogoutButton.accountPreferenceAccount, AccountLogoutButton.otherCode,},
  accountTitle: {AccountTitle.accountPreferenceAccount,},
);
'''));
  });
}
