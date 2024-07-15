import 'dart:io';

import 'package:spdx_license_fetcher/src/license_identification_service.dart';
import 'package:spdx_license_fetcher/src/license_identifier.dart';
import 'package:test/test.dart';

import 'data/input_license_text.dart';

void main() {
  late Directory tempDir;
  late LicenseIdentificationService licenseIdentificationService;
  late TextFileLicenseIdentifier licenseIdentifier;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('license_identifier_test');
    licenseIdentificationService = await LicenseIdentificationServiceImpl.create('licenses', 0.9);
    licenseIdentifier = TextFileLicenseIdentifier(licenseIdentificationService);

    // create temp license files
    await File('${tempDir.path}/mit.txt').writeAsString(mitLicenseText);
    await File('${tempDir.path}/modified_mit.txt').writeAsString(modifiedMitLicenseText);
    await File('${tempDir.path}/highly_modified_mit.txt').writeAsString(highlyModifiedMitLicenseText);
    await File('${tempDir.path}/apache.txt').writeAsString(apacheLicenseText);
    await File('${tempDir.path}/bsd.txt').writeAsString(bsdLicenseText);
    await File('${tempDir.path}/unknown.txt').writeAsString('Unknown');
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group('read the contents of identified license files', () {
    test('should return the spdx license of a single license file', () async {
      final actualSpdxId = await licenseIdentifier.identifySingleLicense('${tempDir.path}/mit.txt');
      expect(actualSpdxId, equals({'MIT' : '${tempDir.path}/mit.txt'}));
    });

    test('should return the spdx license of a modified single license file', () async {
      final actualSpdxId = await licenseIdentifier.identifySingleLicense('${tempDir.path}/modified_mit.txt');
      expect(actualSpdxId, equals({'MIT' : '${tempDir.path}/modified_mit.txt'}));
    });

    test('should not return the spdx license of a highly modified single license file', () async {
      final actualSpdxId = await licenseIdentifier.identifySingleLicense('${tempDir.path}/highly_modified_mit.txt');
      expect(actualSpdxId, equals({'Unknown' : '${tempDir.path}/highly_modified_mit.txt'}));
    });

    test('should return unknown for unknown licenses', () async {
      final actualSpdxId = await licenseIdentifier.identifySingleLicense('${tempDir.path}/unknown.txt');
      expect(actualSpdxId, equals({'Unknown' : '${tempDir.path}/unknown.txt'}));
    });

    test('should return list of spdx licenses correct and unknown for incorrect text', () async {
      final actualSpdxIdsList = await licenseIdentifier.identifyMultipleLicenses([
        '${tempDir.path}/mit.txt',
        '${tempDir.path}/apache.txt'
      ]);
      expect(actualSpdxIdsList.length, 2);
      expect(actualSpdxIdsList, equals({'MIT' : ['${tempDir.path}/mit.txt'], 'Apache-2' : ['${tempDir.path}/apache.txt']}));
    });

    test('should return list of spdx licenses for multiple licenses', () async {
      final actualSpdxIdsList = await licenseIdentifier.identifyMultipleLicenses([
        '${tempDir.path}/mit.txt',
        '${tempDir.path}/modified_mit.txt',        
        '${tempDir.path}/bsd.txt'
      ]);
      expect(actualSpdxIdsList.length, 2);
      expect(actualSpdxIdsList, equals({'MIT' : ['${tempDir.path}/mit.txt', '${tempDir.path}/modified_mit.txt'], '0BSD' : ['${tempDir.path}/bsd.txt']}));
    });
  });
}
