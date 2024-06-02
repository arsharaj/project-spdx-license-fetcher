import 'dart:io';

import 'package:spdx_license_fetcher/src/exceptions.dart';

class FileScanner {
  Future<List<File>> scanDirectory(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      throw DirectoryNotFoundException('The directory at path ${path} does not exist.');
    }

    final licensedFiles = <File>[];
    await for (var file in Directory(path).list(recursive: true)) {
      if (file is File && _isLicenseFile(file)) {
        licensedFiles.add(file);
      }
    }
    return licensedFiles;
  }

  bool _isLicenseFile(File file) {
    final licenseFileNames = {'license', 'license.txt', 'copying', 'notice'};
    return licenseFileNames.contains(file.uri.pathSegments.last.toLowerCase());
  }
}
