## Spdx License Fetcher

> Spdx license fetcher is a dart package to manage license files

### Features

- scans directories for license files
- identifies licenses used in scanned files
- generate reports based on identified licenses

### Library Structure

The spdx license fetcher library provides several key components :

1. `FileScanner` : scan a given directory for license files
2. `LicenseIdentificationService` : identify the type of license based on the license text
3. `TextFileLicenseIdentifier` : identify single or multiple licenses based on the file path
4. `ReportGenerator` : generate reports on the licenses identified in a project

### Example

Here is a brief example of how you can use the spdx license fetcher library in your application :
```dart
import 'dart:io';
import 'package:spdx_license_fetcher/spdx_license_fetcher.dart';

void main() async {
  final directoryPath = 'path/to/your/licenses';
  final errorThreshold = 0.9;
  
  final fileScanner = FileScanner();
  final licenseIdentificationService = await LicenseIdentificationServiceImpl.create(directoryPath, errorThreshold);
  final licenseIdentifier = TextFileLicenseIdentifier(licenseIdentificationService);
  final reportGenerator = ReportGenerator();
  
  final licenseFilePaths = await fileScanner.scanDirectory(directoryPath);
  final licensePaths = licenseFilePaths.map((file) => file.path).toList();
  final identifiedLicenses = await licenseIdentifier.identifyMultipleLicenses(licensePaths);
  final textReport = reportGenerator.generateTextReport(identifiedLicenses);
  
  print(textReport);
}
```

Refer to test suite for more information.