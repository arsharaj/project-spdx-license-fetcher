import 'dart:convert';
import 'dart:io';

class ReportGenerator {
  String generateTextReport(Map<String, List<String>> identifiedLicenses) {
    final buffer = StringBuffer();

    buffer.writeln('## License Declarations');
    buffer.writeln();

    for (var identifiedLicense in identifiedLicenses.keys) {
      buffer.writeln('License-Identifier : $identifiedLicense');
      buffer.writeln('Files :');
      final files = identifiedLicenses[identifiedLicense]!;
      for (var file in files) {
        buffer.writeln('  - $file');
      }
      buffer.writeln();
    }

    return buffer.toString();
  }

  String generateJsonReport(Map<String, List<String>> identifiedLicenses) {
    return json.encode({'licenses': identifiedLicenses});
  }

  Future<void> generateFileReport(Map<String, List<String>> identifiedLicenses, String outputFilePath) async {
    final fileReport = File(outputFilePath);
    await fileReport.writeAsString(generateTextReport(identifiedLicenses));
  }
}
