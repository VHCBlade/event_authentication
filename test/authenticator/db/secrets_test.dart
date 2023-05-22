// ignore_for_file: require_trailing_commas

import 'dart:math';

import 'package:event_authentication/src/authenticator/db/secrets.dart';
import 'package:event_bloc_tester/event_bloc_tester.dart';
import 'package:test/test.dart';

import '../../test_cases.dart';

void main() {
  group('FileSecretsRepository', () {
    group('secrets Getter', secretsGetterTest);
    group('jwtSecret Getter', jwtSecretGetterTest);
    group('generator Getter', generatorGetterTest);
  });
}

void generatorGetterTest() {
  SerializableListTester<Random>(
    testGroupName: 'FileSecretsRepository',
    mainTestName: 'generator Getter',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) async {
      final repository =
          FileSecretsRepository(secretsFile: 'test.json', random: value);
      try {
        // ignore: unused_local_variable
        for (final i in List.generate(20, (index) => index)) {
          final generator = await repository.generator;
          tester.addTestValue(
              generator.generateAuthentication('Amazing').toMap());
          repository.clearSecrets();
        }
      } finally {
        repository.clearSecrets();
      }
    },
    testMap: randomTestCases,
  ).runTests();
}

void jwtSecretGetterTest() {
  SerializableListTester<Random>(
    testGroupName: 'FileSecretsRepository',
    mainTestName: 'jwtSecret Getter',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) async {
      final repository =
          FileSecretsRepository(secretsFile: 'test.json', random: value);
      try {
        for (final i in List.generate(20, (index) => index)) {
          if (i.isOdd) {
            repository.clearSecrets();
          }
          tester.addTestValue(await repository.jwtSecret);
        }
      } finally {
        repository.clearSecrets();
      }
    },
    testMap: randomTestCases,
  ).runTests();
}

void secretsGetterTest() {
  SerializableListTester<Random>(
    testGroupName: 'FileSecretsRepository',
    mainTestName: 'secrets Getter',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) async {
      final repository =
          FileSecretsRepository(secretsFile: 'test.json', random: value);
      try {
        for (final i in List.generate(20, (index) => index)) {
          if (i.isOdd) {
            repository.clearSecrets();
          }
          tester.addTestValue((await repository.secrets).toMap());
        }
      } finally {
        repository.clearSecrets();
      }
    },
    testMap: randomTestCases,
  ).runTests();
}
