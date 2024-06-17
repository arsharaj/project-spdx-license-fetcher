import 'dart:convert';
import 'dart:io';

import 'package:spdx_license_fetcher/src/report_generator.dart';
import 'package:test/test.dart';

final Map<String, List<String>> identifiedLicenses = {
  'MIT': ['mit.txt', 'license.txt'],
  'Apache-2.0': ['apache.txt']
};

void main() {
  late ReportGenerator reportGenerator;

  setUp(() async {
    reportGenerator = ReportGenerator();
  });

  group('generate a simple report of all licenses used in the project', () {
    test('should do nothing', () {});

    test('should generate text report with respective files', () {
      final textReport = reportGenerator.generateTextReport(identifiedLicenses);
      expect(textReport.contains('MIT'), true);
      expect(textReport.contains('Apache-2.0'), true);
      expect(textReport.contains('mit.txt'), true);
      expect(textReport.contains('apache.txt'), true);
    });

    test('should generate text report with no files', () {
      final textReport = reportGenerator.generateTextReport({'MIT': []});
      expect(textReport.contains('MIT'), true);
      expect(textReport.contains('mit.txt'), false);
    });

    test('should generate json report', () {
      final jsonReport = reportGenerator.generateJsonReport(identifiedLicenses);
      expect(jsonReport, json.encode({'licenses': identifiedLicenses}));
    });

    test('should generate json report with no files', () {
      final jsonReport = reportGenerator.generateJsonReport({'MIT': []});
      expect(jsonReport, json.encode({'licenses': {'MIT': []}}));
    });

    test('should generate file report', () async {
      final String outputFileReportPath = 'test' + Platform.pathSeparator + 'sbom.txt';
      await reportGenerator.generateFileReport(identifiedLicenses, outputFileReportPath);

      final fileReport = File(outputFileReportPath);
      expect(await fileReport.exists(), true);
      await fileReport.delete();
    });
  });
}
