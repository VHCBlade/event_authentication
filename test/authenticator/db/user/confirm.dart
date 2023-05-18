import 'dart:math';

import 'package:event_authentication/event_authentication.dart';
import 'package:event_authentication/src/authenticator/db/user.dart';
import 'package:event_bloc_tester/event_bloc_tester.dart';

import '../../../test_cases.dart';

void basicTest() {
  SerializableListTester<DatabaseUserAuthenticator>(
    testGroupName: 'DatabaseUserAuthenticator',
    mainTestName: 'confirmPassword Basic',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) async {
      try {
        final random = Random(250);
        // ignore: unused_local_variable
        for (final i in List.generate(20, (index) => index)) {
          final password = '${random.nextDouble()}';
          const falsePassword = 'fake';
          final model = UserModel()..idSuffix = '${random.nextInt(120)}';
          await value.saveUserAuthentication(model, password);
          tester
            ..addTestValue(password)
            ..addTestValue(await value.confirmPassword(model, password))
            ..addTestValue(await value.confirmPassword(model, falsePassword));
        }
      } finally {
        value.secretsRepository.clearSecrets();
      }
    },
    testMap: databaseUserAuthenticatorTestCases,
  ).runTests();
}

void idExceptionTest() {
  SerializableListTester<DatabaseUserAuthenticator>(
    testGroupName: 'DatabaseUserAuthenticator',
    mainTestName: 'confirmPassword IdException',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) async {
      try {
        final random = Random(1200);
        // ignore: unused_local_variable
        for (final i in List.generate(20, (index) => index)) {
          final password = '${random.nextDouble()}';
          const falsePassword = 'fake';
          final model = UserModel()..idSuffix = '${random.nextInt(120)}';
          await value.saveUserAuthentication(model, password);
          try {
            await value.confirmPassword(UserModel(), password);
          } on UserModelIDException {
            tester.addTestValue(const UserModelIDException().toString());
          }
          tester
            ..addTestValue(password)
            ..addTestValue(await value.confirmPassword(model, password))
            ..addTestValue(await value.confirmPassword(model, falsePassword));
        }
      } finally {
        value.secretsRepository.clearSecrets();
      }
    },
    testMap: databaseUserAuthenticatorTestCases,
  ).runTests();
}

void deleteTest() {
  SerializableListTester<DatabaseUserAuthenticator>(
    testGroupName: 'DatabaseUserAuthenticator',
    mainTestName: 'confirmPassword Delete',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) async {
      try {
        final random = Random(1200);
        // ignore: unused_local_variable
        for (final i in List.generate(20, (index) => index)) {
          final password = '${random.nextDouble()}';
          const falsePassword = 'fake';
          final model = UserModel()..idSuffix = '${random.nextInt(120)}';
          await value.saveUserAuthentication(model, password);
          tester
            ..addTestValue(password)
            ..addTestValue(await value.confirmPassword(model, password))
            ..addTestValue(await value.confirmPassword(model, falsePassword));
          await value.deleteUserAuthentication(model);
          try {
            await value.confirmPassword(model, password);
          } on UserModelIDException {
            tester.addTestValue(const UserModelIDException().toString());
          }
        }
      } finally {
        value.secretsRepository.clearSecrets();
      }
    },
    testMap: databaseUserAuthenticatorTestCases,
  ).runTests();
}
