import 'dart:convert';

/// Obfuscated environment configuration.
/// Keys are XOR-encoded and base64-wrapped to prevent plain-text extraction
/// from decompiled binaries.
class EnvConfig {
  EnvConfig._();

  static const int _m = 0xA7;

  // XOR + base64 encoded values
  static const String _u = 'z9PT19SdiIjE0MvN3cDeydLTxt7KzMjTwsjQ0YnU0tfGxcbUwonEyA==';
  static const String _k = '1MX41MLE1cLT+OjyivTy4MDd18aVkMz/85bh5sLozsD4/+LOn9Kfn5U=';

  static String get supabaseUrl => _d(_u);
  static String get supabaseAnonKey => _d(_k);

  static String _d(String s) {
    final bytes = base64Decode(s);
    return String.fromCharCodes(bytes.map((b) => b ^ _m));
  }
}
