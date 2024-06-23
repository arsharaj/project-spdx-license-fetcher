## License Identifier

> This module is used to identify single or multiple licenses based on the file path

### Features

- identify single license from license file path
- identify multiple licenses from list of license file paths
- easy to integrate and extend

### Usage

Provide `LicenseIdentificationService` as a dependency to `TextFileLicenseIdentifier` and then use either `identifySingleLicense` or `identifyMultipleLicenses` method as per need.

Reference to test suite is recommended.