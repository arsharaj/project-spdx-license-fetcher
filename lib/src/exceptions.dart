class DirectoryNotFoundException implements Exception {
  final String message;

  DirectoryNotFoundException([this.message = 'Directory not found']);

  @override
  String toString() => 'DirectoryNotFoundException : ${this.message}';
}
