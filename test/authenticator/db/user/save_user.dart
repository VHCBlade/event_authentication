import 'dart:math';

import 'package:event_authentication/event_authentication.dart';
import 'package:event_authentication/src/authenticator/db/user.dart';
import 'package:event_bloc_tester/event_bloc_tester.dart';

import '../../../test_cases.dart';

void basicTest() {
  SerializableListTester<DatabaseUserAuthenticator>(
    testGroupName: 'DatabaseUserAuthenticator',
    mainTestName: 'saveUserAuthentication Basic',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) async {
      try {
        final random = Random(120);
        // ignore: unused_local_variable
        for (final i in List.generate(20, (index) => index)) {
          final model = UserModel()..idSuffix = '${random.nextInt(120)}';
          await value.saveUserAuthentication(model, '${random.nextDouble()}');
          tester.addTestValue(
            (await value.findUserAuthentication(model))!.toMap(),
          );
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
    mainTestName: 'saveUserAuthentication IdException',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) async {
      try {
        final random = Random(120);
        // ignore: unused_local_variable
        for (final i in List.generate(20, (index) => index)) {
          final model = UserModel();
          try {
            await value.saveUserAuthentication(model, '${random.nextDouble()}');
          } on UserModelIDException {
            tester.addTestValue(const UserModelIDException().toString());
          }
          model.idSuffix = '${random.nextInt(120)}';
          await value.saveUserAuthentication(model, '${random.nextDouble()}');
          tester.addTestValue(
            (await value.findUserAuthentication(model))!.toMap(),
          );
        }
      } finally {
        value.secretsRepository.clearSecrets();
      }
    },
    testMap: databaseUserAuthenticatorTestCases,
  ).runTests();
}
