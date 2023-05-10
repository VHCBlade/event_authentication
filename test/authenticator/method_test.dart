import 'package:event_authentication/src/authenticator/method.dart';
import 'package:event_bloc_tester/event_bloc_tester.dart';
import 'package:test/test.dart';

import '../test_cases.dart';

void main() {
  group('MethodEncryptDecrypt', () {
    group('isMethod', isMethodTest);
    group('encrypt decrypt', encryptDecryptTest);
    group('Generate Method', () {
      group('Unencrypted', unencryptedTest);
      group('Encrypted', encryptedTest);
    });
  });
}

MethodEncryptDecrypt get _createMethodEncryptDecrypt => MethodEncryptDecrypt(
      minHashes: 1,
      maxHashes: 100,
      saltBase64: '6E8sXS9kjg+urKe8B5JZv7cXqXm/y04+Bjwl0SW0EhM=',
      ivBase64: 'aQ6paoFZ0oXv1VexA9MhCg==',
    );

void encryptDecryptTest() {
  SerializableListTester<List<String>>(
    testGroupName: 'MethodEncryptDecrypt',
    mainTestName: 'encrypted decrypted',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) {
      final encryptDecrypt = _createMethodEncryptDecrypt;
      for (final method in value) {
        tester.addTestValue(method);
        try {
          final encrypted = encryptDecrypt.encryptMethod(method);
          tester
            ..addTestValue(encrypted)
            ..addTestValue(encryptDecrypt.decryptMethod(encrypted));
        } on NotMethodException {
          tester.addTestValue('Failed, not a method!');
        }
      }
    },
    testMap: methodTestCases,
  ).runTests();
}

void isMethodTest() {
  SerializableListTester<List<String>>(
    testGroupName: 'MethodEncryptDecrypt',
    mainTestName: 'isMethod',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) {
      final encryptDecrypt = _createMethodEncryptDecrypt;
      for (final method in value) {
        tester
          ..addTestValue(method)
          ..addTestValue(encryptDecrypt.isMethod(method));
      }
    },
    testMap: methodTestCases,
  ).runTests();
}

void encryptedTest() {
  SerializableListTester<MethodEncryptDecrypt>(
    testGroupName: 'Generate Method',
    mainTestName: 'Encrypted',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) {
      // ignore: unused_local_variable
      for (final i in List.generate(50, (index) => 0)) {
        final method = value.generateEncryptedMethod();
        tester
          ..addTestValue(method)
          ..addTestValue(value.decryptMethod(method));
      }
    },
    testMap: methodEncryptDecryptTestCases,
  ).runTests();
}

void unencryptedTest() {
  SerializableListTester<MethodEncryptDecrypt>(
    testGroupName: 'Generate Method',
    mainTestName: 'Unencrypted',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) {
      // ignore: unused_local_variable
      for (final i in List.generate(50, (index) => 0)) {
        tester.addTestValue(value.generateMethod());
      }
    },
    testMap: methodEncryptDecryptTestCases,
  ).runTests();
}
