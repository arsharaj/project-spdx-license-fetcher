import 'dart:io';

import 'package:spdx_license_fetcher/src/exceptions.dart';

class FileScanner {
  Future<List<File>> scanDirectory(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      var message = 'The directory at path ${path} does not exist.';
      throw DirectoryNotFoundException(message);
    }

    final licensedFiles = <File>[];
    await for (var file in directory.list(recursive: true)) {
      if (file is File && _isLicenseFile(file)) {
        licensedFiles.add(file);
      }
    }

    return licensedFiles;
  }

  bool _isLicenseFile(File file) {
    final validNames = {'license', 'license.txt', 'copying', 'notice'};
    var currentName = file.uri.pathSegments.last.toLowerCase();
    return validNames.contains(currentName);
  }
}
