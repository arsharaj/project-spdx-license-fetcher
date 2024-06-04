import 'dart:io';

import 'package:spdx_license_fetcher/src/license_identifier.dart';
import 'package:test/test.dart';

const String _mitLicenseText = '''
MIT License

Copyright (c) [year] [fullname]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
''';

const String _modifiedMitLicenseText = '''
MIT License

Copyright (c) 2021 Example Inc

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
''';

const String _highlyModifiedMitLicenseText = '''
MIT License

Copyright (c) 2021 Example Inc

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
''';

const String _apacheLicenseText = '''
Copyright [yyyy] [name of copyright owner]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
''';

void main() {
  late Directory tempDir;
  late LicenseIdentifier licenseIdentifier;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('license_identifier_test');
    licenseIdentifier = LicenseIdentifier();

    // create temp license files
    await File('${tempDir.path}/mit.txt').writeAsString(_mitLicenseText);
    await File('${tempDir.path}/modified_mit.txt').writeAsString(_modifiedMitLicenseText);
    await File('${tempDir.path}/highly_modified_mit.txt').writeAsString(_highlyModifiedMitLicenseText);
    await File('${tempDir.path}/apache.txt').writeAsString(_apacheLicenseText);
    await File('${tempDir.path}/unknown.txt').writeAsString('Unknown');
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group('read the contents of identified license files', () {
    test('should return the spdx license of a single license file', () async {
      final actualSpdxId = await licenseIdentifier.identifySingleLicense('${tempDir.path}/mit.txt');
      expect(actualSpdxId, equals('MIT'));
    });

    test('should return the spdx license of a modified single license file', () async {
      final actualSpdxId = await licenseIdentifier.identifySingleLicense('${tempDir.path}/modified_mit.txt');
      expect(actualSpdxId, equals('MIT'));
    });

    test('should not return the spdx license of a highly modified single license file', () async {
      final actualSpdxId = await licenseIdentifier.identifySingleLicense('${tempDir.path}/highly_modified_mit.txt');
      expect(actualSpdxId, equals('Unknown'));
    });

    test('should return unknown for unknown licenses', () async {
      final actualSpdxId = await licenseIdentifier.identifySingleLicense('${tempDir.path}/unknown.txt');
      expect(actualSpdxId, equals('Unknown'));
    });

    test('should return list of spdx licenses of multiple license files', () async {
      final actualSpdxIdsList = await licenseIdentifier.identifyMultipleLicenses([
        '${tempDir.path}/mit.txt',
        '${tempDir.path}/apache.txt'
      ]);
      expect(actualSpdxIdsList, ['MIT', 'Apache-2.0']);
    });
  });
}
