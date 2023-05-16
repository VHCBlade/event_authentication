import 'package:event_authentication/event_authentication.dart';
import 'package:event_bloc_tester/event_bloc_tester.dart';
import 'package:test/test.dart';

import 'test_cases.dart';

void main() {
  group('UserAuthentication', () {
    group('userId', userIdTest);
  });
}

void userIdTest() {
  SerializableListTester<UserModel>(
    testGroupName: 'UserAuthentication',
    mainTestName: 'userId',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) {
      final authentication = UserAuthentication();
      tester
        ..addTestValue(authentication.userId)
        ..addTestValue(value.id);
      authentication.userId = value.id;
      tester
        ..addTestValue(authentication.id)
        ..addTestValue(authentication.userId);
    },
    testMap: userModelTestCases,
  ).runTests();
}
