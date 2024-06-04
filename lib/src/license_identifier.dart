import 'dart:io';

import 'package:spdx_license_fetcher/src/spdx_licenses.dart';
import 'package:string_similarity/string_similarity.dart';

class LicenseIdentifier {
  final _threshold = 0.9;  // default minimum similarity threshold

  Future<String> identifySingleLicense(String licenseFilePath) async {
    String licenseFileContent = await File(licenseFilePath).readAsString();
    return await _identifyLicense(licenseFileContent);
  }

  Future<List<String>> identifyMultipleLicenses(List<String> licensesFilePaths) async {
    final identifiersList = <String>[];
    for (var path in licensesFilePaths) {
      identifiersList.add(await identifySingleLicense(path));
    }
    return identifiersList;
  }
  
  String _identifyLicense(String licenseFileContent) {
    String bestMatch = 'Unknown';
    double bestScore = 0.0;
    for (var identifier in spdxLicensesIdentifierToContent.entries) {
      final score = licenseFileContent.similarityTo(identifier.value);
      if (score > bestScore && score >= _threshold) {
        bestMatch = identifier.key;
        bestScore = score;
      }
    }
    return bestMatch;
  }
}
