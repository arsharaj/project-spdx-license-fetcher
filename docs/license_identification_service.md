## License Identification Service

> This module is used to identify the type of license based on the license text

### Features

- identifies the type of license from the provided text using string similarity matching algorithm

### Usage

To use the `LicenseIdentificationService` to identify the type of license from the license text, import the package and call the `identifyLicense` method with the license text.

To create an instance of LicenseIdentificationService use :
```dart
final licenseIdentificationService = await LicenseIdentificationServiceImpl.create('path to spdx licenses directory', errorThreshold);
```

This package is tested upon licenses under spdx license list 3.24.0 version. Refer to test suite if needed.