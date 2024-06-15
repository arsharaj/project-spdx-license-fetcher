import 'dart:io';

import 'package:spdx_license_fetcher/src/license_identification_service.dart';

class TextFileLicenseIdentifier {
  late LicenseIdentificationService licenseIdentificationService;

  TextFileLicenseIdentifier(this.licenseIdentificationService);

  Future<Map<String, String>> identifySingleLicense(String licenseFilePath) async {
    String licenseFileContent = await File(licenseFilePath).readAsString();
    return await licenseIdentificationService.identifyLicense(licenseFileContent);
  }

  Future<List<Map<String, String>>> identifyMultipleLicenses(List<String> licensesFilePaths) async {
    final identifiersList = <Map<String, String>>[];
    for (var path in licensesFilePaths) {
      identifiersList.add(await identifySingleLicense(path));
    }
    return identifiersList;
  }
}