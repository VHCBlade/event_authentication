import 'package:event_authentication/event_authentication.dart';
import 'package:event_authentication/src/authenticator/generator.dart';
import 'package:event_bloc_tester/event_bloc_tester.dart';
import 'package:event_db/event_db.dart';
import 'package:test/test.dart';

import '../test_cases.dart';

void main() {
  group('UserAuthenticationGenerator', () {
    group('generateAuthentication', generateAuthenticationTest);
    group('confirmAuthentication', confirmAuthenticationTest);
  });
}

const _testPasswords = [
  'password',
  '12345',
  '20139',
  'ASls#10213fjssoP',
  r'!@#$%^&*()',
];

void generateAuthenticationTest() {
  SerializableListTester<UserAuthenticationGenerator>(
    testGroupName: 'UserAuthenticationGenerator',
    mainTestName: 'generateAuthentication',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) {
      for (final testPassword in _testPasswords) {
        tester.addTestValue(value.generateAuthentication(testPassword).toMap());
      }
    },
    testMap: userAuthenticationGeneratorTestCases,
  ).runTests();
}

void confirmAuthenticationTest() {
  SerializableListTester<UserAuthenticationGenerator>(
    testGroupName: 'UserAuthenticationGenerator',
    mainTestName: 'generateAuthentication',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) {
      for (final testPassword in _testPasswords) {
        final userAuthentication = value.generateAuthentication(testPassword);
        tester.addTestValue(userAuthentication.toMap());
        final usedAuthentication = UserAuthentication()
          ..copy(userAuthentication);

        expect(
          true,
          value.confirmAuthentication(
            usedAuthentication,
            testPassword,
          ),
        );

        expect(
          false,
          value.confirmAuthentication(
            usedAuthentication,
            '$testPassword ',
          ),
        );

        expect(
          false,
          value.confirmAuthentication(
            usedAuthentication,
            'asfes$testPassword ',
          ),
        );

        expect(
          false,
          value.confirmAuthentication(
            usedAuthentication,
            '1235r',
          ),
        );
      }
    },
    testMap: userAuthenticationGeneratorTestCases,
  ).runTests();
}
