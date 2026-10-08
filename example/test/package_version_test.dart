import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:example/docs/package_version.dart';

void main() {
  test('docs show the package version from pubspec.yaml', () {
    final pubspec = File('../pubspec.yaml').readAsStringSync();
    final version = RegExp(
      r'^version:\s*(\S+)',
      multiLine: true,
    ).firstMatch(pubspec)!.group(1);
    expect(packageVersion, version);
  });
}
