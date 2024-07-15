import 'dart:io';

import 'package:spdx_license_fetcher/spdx_license_fetcher.dart';
import 'package:test/test.dart';

import 'data/input_license_text.dart';

void main() {
  late Directory tempDir;
  late FileScanner fileScanner;
  late LicenseIdentificationService licenseIdentificationService;
  late TextFileLicenseIdentifier licenseIdentifier;
  late ReportGenerator reportGenerator;

  final _licenseDirectoryPath = 'licenses';
  final _errorThreshold = 0.9;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('spdx_license_fetcher_test');
    fileScanner = FileScanner();
    licenseIdentificationService = await LicenseIdentificationServiceImpl.create(_licenseDirectoryPath, _errorThreshold);
    licenseIdentifier = TextFileLicenseIdentifier(licenseIdentificationService);
    reportGenerator = ReportGenerator();

    // Create temporary license files
    await File('${tempDir.path}${Platform.pathSeparator}license').writeAsString(mitLicenseText);
    await File('${tempDir.path}${Platform.pathSeparator}license.txt').writeAsString(bsdLicenseText);
    await File('${tempDir.path}${Platform.pathSeparator}COPYING').writeAsString(highlyModifiedMitLicenseText);
    await File('${tempDir.path}${Platform.pathSeparator}NOTICE').writeAsString(apacheLicenseText);
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group('spdx license fetcher integration test', () {
    test('should scan directory, identify licenses, and generate a text report', () async {
      final licenseFilePaths = await fileScanner.scanDirectory(tempDir.path);
      final licensePaths = licenseFilePaths.map((file) => file.path).toList();
      final identifiedLicenses = await licenseIdentifier.identifyMultipleLicenses(licensePaths);
      final textReport = reportGenerator.generateTextReport(identifiedLicenses);
      expect(textReport.contains('MIT'), true);
      expect(textReport.contains('Apache-2'), true);
      expect(textReport.contains('0BSD'), true);
    });
  });
}
