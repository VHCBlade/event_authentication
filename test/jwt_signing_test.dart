import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:event_authentication/event_authentication.dart';
import 'package:event_bloc_tester/event_bloc_tester.dart';
import 'package:test/test.dart';

import 'test_cases.dart';

void main() {
  group('JWTSigning', () {
    group('Normal', normalSigningTest);
    group('Expired', expiredSigningTest);
    group('Wrong Issuer', wrongIssuerTest);
    group('Wrong Secret', wrongSecretTest);
    group('Wrong Format', wrongFormatTest);
    group('Wrong Inner Format', wrongInnerFormatTest);
  });
}

void wrongInnerFormatTest() {
  SerializableListTester<UserModel>(
    testGroupName: 'JWTSigning',
    mainTestName: 'Wrong Inner Format',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) async {
      final signer = JWTSigner(() => value.idSuffix!, issuer: 'example.com');
      final jwt = JWT('This is Amazing', issuer: 'example.com');
      final token = jwt.sign(SecretKey(value.idSuffix!));
      try {
        await signer.validateAndDecodeToken(token);
      } on JWTInvalidException catch (e) {
        tester
          ..addTestValue('Invalid!')
          ..addTestValue(e.message);
      }
    },
    testMap: userModelTestCases,
  ).runTests();
}

void wrongFormatTest() {
  SerializableListTester<UserModel>(
    testGroupName: 'JWTSigning',
    mainTestName: 'Wrong Format',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) async {
      final signer = JWTSigner(() => value.idSuffix!, issuer: 'example.com');
      try {
        await signer.validateAndDecodeToken('${value.toMap()}');
      } on JWTInvalidException catch (e) {
        tester
          ..addTestValue('Invalid!')
          ..addTestValue(e.message);
      }
    },
    testMap: userModelTestCases,
  ).runTests();
}

void wrongSecretTest() {
  SerializableListTester<UserModel>(
    testGroupName: 'JWTSigning',
    mainTestName: 'Wrong Secret',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) async {
      final signer = JWTSigner(() => value.idSuffix!, issuer: 'example.com');
      final signer2 =
          JWTSigner(() => '${value.idSuffix!}a', issuer: 'example.com');
      final jwt = BaseJWT.fromUserModel(value)
        ..dateIssued = DateTime(2022)
        ..expiry = const Duration(days: 365 * 100);
      tester.addTestValue(jwt.toMap());

      final token = await signer.createToken(jwt);
      try {
        await signer2.validateAndDecodeToken(token);
      } on JWTInvalidException catch (e) {
        tester
          ..addTestValue('Invalid!')
          ..addTestValue(e.message);
      }
    },
    testMap: userModelTestCases,
  ).runTests();
}

void wrongIssuerTest() {
  SerializableListTester<UserModel>(
    testGroupName: 'JWTSigning',
    mainTestName: 'Wrong Issuer',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) async {
      final signer = JWTSigner(() => value.idSuffix!, issuer: 'example.com');
      final signer2 = JWTSigner(() => value.idSuffix!, issuer: 'example.io');
      final jwt = BaseJWT.fromUserModel(value)
        ..dateIssued = DateTime(2022)
        ..expiry = const Duration(days: 365 * 100);
      tester.addTestValue(jwt.toMap());

      final token = await signer.createToken(jwt);
      try {
        await signer2.validateAndDecodeToken(token);
      } on JWTInvalidException catch (e) {
        tester
          ..addTestValue('Invalid!')
          ..addTestValue(e.message);
      }
    },
    testMap: userModelTestCases,
  ).runTests();
}

void expiredSigningTest() {
  SerializableListTester<UserModel>(
    testGroupName: 'JWTSigning',
    mainTestName: 'Expired',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) async {
      final signer = JWTSigner(() => value.idSuffix!, issuer: 'example.com');
      final jwt = BaseJWT.fromUserModel(value)
        ..dateIssued = DateTime(2020)
        ..expiry = const Duration(days: 365 * 1);
      tester.addTestValue(jwt.toMap());

      final token = await signer.createToken(jwt);
      try {
        await signer.validateAndDecodeToken(token);
      } on JWTExpiredException {
        tester.addTestValue('Expired!');
      }
    },
    testMap: userModelTestCases,
  ).runTests();
}

void normalSigningTest() {
  SerializableListTester<UserModel>(
    testGroupName: 'JWTSigning',
    mainTestName: 'Normal',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) async {
      final signer = JWTSigner(() => value.idSuffix!, issuer: 'example.com');
      final jwt = BaseJWT.fromUserModel(value)
        ..dateIssued = DateTime(2020)
        ..expiry = const Duration(days: 365 * 100);
      tester.addTestValue(jwt.toMap());

      final token = await signer.createToken(jwt);
      final decodedJwt = await signer.validateAndDecodeToken(token);
      tester.addTestValue(decodedJwt.toMap());
      expect(jwt.hasSameFields(model: decodedJwt), true);
    },
    testMap: userModelTestCases,
  ).runTests();
}
