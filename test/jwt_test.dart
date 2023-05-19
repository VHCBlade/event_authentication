import 'package:event_authentication/event_authentication.dart';
import 'package:event_bloc_tester/event_bloc_tester.dart';
import 'package:test/test.dart';

import 'test_cases.dart';

void main() {
  group('BaseJWT', () {
    test('isExpired', isExpiredTest);
  });
  group('JWTRole', () {
    group('containsRole', jwtRoleContainsTest);
    group('containsAnyRole', jwtRoleContainsAnyTest);
  });
}

void isExpiredTest() {
  final jwtNow = BaseJWT();
  final jwtYesterday = BaseJWT()
    ..dateIssued = DateTime.now().subtract(const Duration(days: 1));
  expect(jwtNow.isExpired, true);
  expect((jwtNow..expiry = const Duration(seconds: 20)).isExpired, false);
  expect(jwtYesterday.isExpired, true);
  expect((jwtYesterday..expiry = const Duration(seconds: 20)).isExpired, true);
  expect(
      (jwtYesterday..expiry = const Duration(days: 1, seconds: 20)).isExpired,
      false);
}

void jwtRoleContainsTest() {
  SerializableListTester<JWTRole>(
    testGroupName: 'JWTRole',
    mainTestName: 'containsRole',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) {
      tester
        ..addTestValue(value.containsRole('Amazing'))
        ..addTestValue(value.containsRole('Incredible'))
        ..addTestValue(value.containsRole('Nothing'))
        ..addTestValue(value.containsRole('Null'))
        ..addTestValue(value.containsRole('null'))
        ..addTestValue(value.containsRole('None'))
        ..addTestValue(value.containsRole('0'));
    },
    testMap: jwtRoleTestCases,
  ).runTests();
}

void jwtRoleContainsAnyTest() {
  SerializableListTester<JWTRole>(
    testGroupName: 'JWTRole',
    mainTestName: 'containsAnyRole',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) {
      tester
        ..addTestValue(value.containsAnyRoles(['Amazing']))
        ..addTestValue(value.containsAnyRoles(['Incredible', '0']))
        ..addTestValue(value.containsAnyRoles(['Play', 'Cool']))
        ..addTestValue(value.containsAnyRoles(['Incredible', 'Meh']))
        ..addTestValue(value.containsAnyRoles(['Cool', 'Amazing']));
    },
    testMap: jwtRoleTestCases,
  ).runTests();
}
