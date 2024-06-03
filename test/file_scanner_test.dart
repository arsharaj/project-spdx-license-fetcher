import 'dart:io';

import 'package:spdx_license_fetcher/src/exceptions.dart';
import 'package:spdx_license_fetcher/src/file_scanner.dart';
import 'package:test/test.dart';

void main() {
  late Directory testDir;
  late FileScanner fileScanner;

  setUp(() async {
    testDir = await Directory.systemTemp.createTemp("license_test_dir");
    fileScanner = FileScanner();

    // create test files
    await File('${testDir.path}/license').writeAsString('MIT License');
    await File('${testDir.path}/license.txt').writeAsString('Apache License');
    await File('${testDir.path}/readme').writeAsString('This is a readme file.');
    await File('${testDir.path}/subdir/LICENSE').create(recursive: true);
    await File('${testDir.path}/subdir/COPYING').writeAsString('GPL License');
  });

  tearDown(() {
    testDir.delete(recursive: true);
  });

  group('scan my project directory for license files', () {
    test('should scan the directory, subdirectory and find license files', () async {
      // arrange
      final expectedFiles = [
        '${testDir.path}\\license',
        '${testDir.path}\\license.txt',
        '${testDir.path}\\subdir\\LICENSE',
        '${testDir.path}\\subdir\\COPYING'
      ];
      // act
      final files = await fileScanner.scanDirectory(testDir.path);
      // assert
      expect(files.map((file) => file.path).toList(), unorderedEquals(expectedFiles));
    });

    test('should not find non-license files', () async {
      // arrange
      final files = await fileScanner.scanDirectory(testDir.path);
      // act
      final nonLicensedFiles = files.where((file) => !file.path.contains(RegExp(r'license|copying')));
      // assert
      expect(nonLicensedFiles, isEmpty);
    });

    test('should throw DirectoryNotFoundException for non-existent directory', () async {
      // assert
      expect(() async => await fileScanner.scanDirectory(''), throwsA(isA<DirectoryNotFoundException>()));
    });
  });
}
