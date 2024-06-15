import 'dart:io';

import 'package:spdx_license_fetcher/src/exceptions.dart';
import 'package:string_similarity/string_similarity.dart';

abstract class LicenseIdentificationService {
  Map<String, String> identifyLicense(String licenseContent);
}

class LicenseIdentificationServiceImpl implements LicenseIdentificationService {
  Map<String, String> _spdxLicenses = {};
  late double _threshold;
  late String _licensesDirectoryPath;

  LicenseIdentificationServiceImpl._(String _licensesDirectoryPath, double _errorThreshold) {
    this._licensesDirectoryPath = _licensesDirectoryPath;
    this._threshold = _errorThreshold;
  }

  static Future<LicenseIdentificationServiceImpl> create(String _licensesDirectoryPath, double _errorThreshold) async {
    final licenseIdentificationServiceImpl = LicenseIdentificationServiceImpl._(_licensesDirectoryPath, _errorThreshold);
    await licenseIdentificationServiceImpl._loadSpdxLicenses();
    return licenseIdentificationServiceImpl;
  }

  Future<void> _loadSpdxLicenses() async {
    final directory = Directory(_licensesDirectoryPath);
    if (!await directory.exists()) {
      String message = 'The directory at path ${_licensesDirectoryPath} does not exist.';
      throw DirectoryNotFoundException(message);
    }

    final licenseFiles = directory.listSync();
    for (var license in licenseFiles) {
      if (license is File) {
        final licenseId = license.uri.pathSegments.last.split('.').first;
        final licenseText = await license.readAsString();
        _spdxLicenses[licenseId] = licenseText;
      } else {
        throw FileNotValidException();
      }
    }
  }

  @override
  Map<String, String> identifyLicense(String licenseContent) {
    String bestMatchKey = 'Unknown';
    String bestMatchValue = '';
    double bestScore = 0.0;

    final normalizedLicenseFileContent = licenseContent.replaceAll(RegExp(r'\s+'), '');

    for (var identifier in _spdxLicenses.entries) {
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