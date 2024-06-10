import 'dart:io';

import 'package:spdx_license_fetcher/src/exceptions.dart';
import 'package:string_similarity/string_similarity.dart';

abstract class LicenseIdentifier {
  Future<void> _loadSpdxLicenses(String licensesDirectoryPath);
}

class TextFileLicenseIdentifier implements LicenseIdentifier {
  final Map<String, String> spdxLicenses = {};
  final _threshold = 0.9; // default minimum similarity threshold
  static final _licensesDirectoryPath = "licenses";

  TextFileLicenseIdentifier._();

  static Future<TextFileLicenseIdentifier> create() async {
    final textFileLicenseIdentifier = TextFileLicenseIdentifier._();
    await textFileLicenseIdentifier._loadSpdxLicenses(_licensesDirectoryPath);
    return textFileLicenseIdentifier;
  }

  @override
  Future<void> _loadSpdxLicenses(String licensesDirectoryPath) async {
    final directory = Directory(licensesDirectoryPath);
    if (!await directory.exists()) {
      String message = 'The directory at path ${licensesDirectoryPath} does not exist.';
      throw DirectoryNotFoundException(message);
    }

    final licenseFiles = directory.listSync();
    for (var license in licenseFiles) {
      if (license is File) {
        final licenseId = license.uri.pathSegments.last.split('.').first;
        final licenseText = await license.readAsString();
        spdxLicenses[licenseId] = licenseText;
      } else {
        throw FileNotValidException();
      }
    }
  }

  Future<Map<String, String>> identifySingleLicense(String licenseFilePath) async {
    String licenseFileContent = await File(licenseFilePath).readAsString();
    return await _identifyLicense(licenseFileContent);
  }

  Future<List<Map<String, String>>> identifyMultipleLicenses(List<String> licensesFilePaths) async {
    final identifiersList = <Map<String, String>>[];
    for (var path in licensesFilePaths) {
      identifiersList.add(await identifySingleLicense(path));
    }
    return identifiersList;
  }
  
  Map<String, String> _identifyLicense(String licenseFileContent) {
    String bestMatchKey = 'Unknown';
    String bestMatchValue = '';
    double bestScore = 0.0;

    final normalizedLicenseFileContent = licenseFileContent.replaceAll(RegExp(r'\s+'), '');

    for (var identifier in spdxLicenses.entries) {
      final normalizedSpdxLicenseText = identifier.value.replaceAll(RegExp(r'\s+'), '');
      final score = normalizedLicenseFileContent.similarityTo(normalizedSpdxLicenseText);
      if (score > bestScore && score >= _threshold) {
        bestMatchKey = identifier.key;
        bestMatchValue = identifier.value;
        bestScore = score;
      }
    }
    return {bestMatchKey : bestMatchValue};
  }
}