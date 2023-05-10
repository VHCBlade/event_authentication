import 'dart:math';

import 'package:event_authentication/src/authenticator/hash.dart';
import 'package:event_bloc_tester/event_bloc_tester.dart';
import 'package:test/test.dart';

import '../test_cases.dart';

void main() {
  group('PasswordHasher', () {
    group('Salt', saltTest);
    group('Separate Method', separateMethodTest);
    group('Append Password', appendPasswordTest);
    group('Individual Hash', individualHashTest);
    group('Hash', hashTest);
  });
}

PasswordHasher get _createPasswordHasher => PasswordHasher(
      pepper: '6E8sXS9kjg+urKe8B5JZv7cXqXm/y04+Bjwl0SW0EhM=',
      random: Random(120),
    );

void hashTest() {
  SerializableListTester<List<String>>(
    testGroupName: 'PasswordHasher',
    mainTestName: 'Hash',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) {
      final passwordHasher = _createPasswordHasher;

      for (final method in value) {
        try {
          final salt = passwordHasher.generateSalt(length: 32);
          tester.addTestValue(method);
          final hash =
              passwordHasher.hash(method: method, salt: salt, password: method);
          tester
            ..addTestValue(hash)
            ..addTestValue(
              hash ==
                  passwordHasher.hash(
                    method: method,
                    salt: salt,
                    password: method,
                  ),
            );
        } on FormatException {
          tester.addTestValue('Failed! Format Exception');
          // ignore: avoid_catching_errors
        } on ArgumentError {
          tester.addTestValue('Failed! Password Append is Incorrect!');
        }
      }
    },
    testMap: methodTestCases,
  ).runTests();
}

void individualHashTest() {
  SerializableListTester<List<String>>(
    testGroupName: 'PasswordHasher',
    mainTestName: 'Individual Hash',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) {
      final passwordHasher = _createPasswordHasher;

      for (final method in value) {
        tester.addTestValue(method);
        final hash = passwordHasher.individualHash(method);
        tester
          ..addTestValue(hash)
          ..addTestValue(hash == passwordHasher.individualHash(method));
      }
    },
    testMap: methodTestCases,
  ).runTests();
}

void appendPasswordTest() {
  SerializableListTester<List<String>>(
    testGroupName: 'PasswordHasher',
    mainTestName: 'Append Password',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) {
      final passwordHasher = _createPasswordHasher;

      for (final method in value) {
        tester.addTestValue(method);
        try {
          final separated = passwordHasher.separateMethod(method);
          final appendedPassword = passwordHasher.appendPassword(
            password: method,
            salt: _createPasswordHasher.generateSalt(length: 32),
            passwordAppend: separated.item1,
          );
          tester.addTestValue(appendedPassword);
        } on FormatException {
          tester.addTestValue('Failed! Format Exception');
          // ignore: avoid_catching_errors
        } on ArgumentError {
          tester.addTestValue('Failed! Password Append is Incorrect!');
        }
      }
    },
    testMap: methodTestCases,
  ).runTests();
}

void saltTest() {
  SerializableListTester<PasswordHasher>(
    testGroupName: 'PasswordHasher',
    mainTestName: 'Salt',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) {
      // ignore: unused_local_variable
      for (final i in List.generate(20, (index) => 0)) {
        tester
          ..addTestValue(value.generateSalt())
          ..addTestValue(value.generateSalt(length: 16))
          ..addTestValue(value.generateSalt(length: 64));
      }
    },
    testMap: passwordHasherTestCases,
  ).runTests();
}

void separateMethodTest() {
  SerializableListTester<List<String>>(
    testGroupName: 'PasswordHasher',
    mainTestName: 'Separate Method',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) {
      final passwordHasher = _createPasswordHasher;
      for (final method in value) {
        tester.addTestValue(method);
        try {
          final separated = passwordHasher.separateMethod(method);
          tester
            ..addTestValue(separated.item1)
            ..addTestValue(separated.item2);
        } on FormatException {
          tester.addTestValue('Failed! Format Exception');
        }
      }
    },
    testMap: methodTestCases,
  ).runTests();
}
