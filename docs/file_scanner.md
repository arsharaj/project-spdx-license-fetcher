## File Scanner

> This module is designed to scan a given directory and identify license files.

### Features

- scans a specified directory and its subdirectories for license files
- identifies common license file names ('license', 'license.txt', 'copying', 'notice')
- throws an exception if the specified directory is not found

### Usage

To use the `FileScanner` class, simply import the package and call the `scanDirectory` method with the path of the directory you want to scan. A `DirectoryNotFoundException` is thrown when the specified directory does not exist.

Refer to test suite if needed.