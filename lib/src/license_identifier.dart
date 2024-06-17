import 'dart:io';

import 'package:spdx_license_fetcher/src/license_identification_service.dart';

class TextFileLicenseIdentifier {
  late LicenseIdentificationService licenseIdentificationService;

  TextFileLicenseIdentifier(this.licenseIdentificationService);

  Future<Map<String, String>> identifySingleLicense(String licenseFilePath) async {
    String licenseFileContent = await File(licenseFilePath).readAsString();
    String licenseType = licenseIdentificationService.identifyLicense(licenseFileContent);
    return {licenseType: licenseFilePath};
  }

  Future<Map<String, List<String>>> identifyMultipleLicenses(List<String> licenseFilePaths) async {
    final licenseIdentifierMap = Map<String, List<String>>();

    for (var licenseFilePath in licenseFilePaths) {
      Map<String, String> identifier = await identifySingleLicense(licenseFilePath);
      String licenseType = identifier.keys.first;
      String filePath = identifier.values.first;
      licenseIdentifierMap.putIfAbsent(licenseType, () => []).add(filePath);
    }
    
    return licenseIdentifierMap;
  }
}
