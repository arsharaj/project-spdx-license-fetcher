import 'package:spdx_license_fetcher/src/license_identification_service.dart';
import 'package:test/test.dart';

import 'data/input_license_text.dart';

void main() {
  late LicenseIdentificationService licenseIdentificationService;

  setUp(() async {
    licenseIdentificationService = await LicenseIdentificationServiceImpl.create('licenses', 0.9);
  });

  tearDown(() {});

  group('identify the type of license from the license text', () {
    test('should do nothing', () {});

    test('should return the correct license for MIT', () {
      expect(licenseIdentificationService.identifyLicense(mitLicenseText), 'MIT');
    });

    test('should return the correct license for Apache-2.0', () {
      expect(licenseIdentificationService.identifyLicense(apacheLicenseText), 'Apache-2');
    });

    test('should return unknown for non-matching license', () {
      expect(licenseIdentificationService.identifyLicense('This is an unknown text.'), 'Unknown');
    });

    test('should return the correct license for modified MIT', () {
      expect(licenseIdentificationService.identifyLicense(modifiedMitLicenseText), 'MIT');
    });

    test('should return Unknown for text below similarity threshold', () {
      expect(licenseIdentificationService.identifyLicense(highlyModifiedMitLicenseText), 'Unknown');
    });
  });
}