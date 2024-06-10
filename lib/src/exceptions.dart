class DirectoryNotFoundException implements Exception {
  final String message;

  DirectoryNotFoundException([this.message = 'Directory not found']);

  @override
  String toString() => 'DirectoryNotFoundException : ${this.message}';
}

class FileNotValidException implements Exception {
  final String message;

  FileNotValidException([this.message = 'Invalid file in the licenses directory']);

  @override
  String toString() => 'FileNotValidException : ${this.message}';
}
