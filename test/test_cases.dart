import 'dart:math';

import 'package:event_authentication/event_authentication.dart';
import 'package:event_authentication/event_authenticator.dart';

Map<String, List<String> Function()> get methodTestCases => {
      'Standard': () =>
          ['PSB89', 'PBS102310', 'BSP1000', 'SPB1', 'SBP100', 'BPS601'],
      'More': () => ['PPSB10', 'SBPPBS10203', 'SSBP1', 'SSSPB102', 'SSP21'],
      'Fake': () =>
          ['10PSB10', 'PBS', 'BS120', 'B1', '', 'PSB', 'psb102', 'ABC102'],
      'Zero': () => ['PSB0', 'PBS0', 'BSP000', 'SPB0', 'SBP00', 'BPS0'],
    };

Map<String, UserModel Function()> get userModelTestCases => {
      'Empty': () => UserModel()..idSuffix = 'Empty',
      'Username': () => UserModel()
        ..idSuffix = 'Username'
        ..username = 'I am Amazing',
      'Email': () => UserModel()
        ..idSuffix = 'Empty'
        ..username = 'Incredible'
        ..email = 'ex@example.com',
    };

Map<String, MethodEncryptDecrypt Function()>
    get methodEncryptDecryptTestCases => {
          '1-1': () => MethodEncryptDecrypt(
                minHashes: 1,
                maxHashes: 1,
                saltBase64: '6E8sXS9kjg+urKe8B5JZv7cXqXm/y04+Bjwl0SW0EhM=',
                ivBase64: 'igbwoL+P/Gl1Jksgi3qKDg==',
                random: Random(120),
              ),
          '1-10': () => MethodEncryptDecrypt(
                minHashes: 1,
                maxHashes: 10,
                ivBase64: 'aQ6paoFZ0oXv1VexA9MhCg==',
                saltBase64: 'pT5eeD5weGCGLh8PV1pHhD0TGo/4nN0G/2t3LFaGD4U=',
                random: Random(74),
              ),
          '10-10': () => MethodEncryptDecrypt(
                minHashes: 10,
                maxHashes: 10,
                ivBase64: 'Dg5fhTKaNBX2a5MFdm8MsA==',
                saltBase64: '3vbO6UkkC4QWo3hfLEIgQ4LJAn4QyH1Pjt0vcRWdLEo=',
                random: Random(53),
              ),
          '20-100': () => MethodEncryptDecrypt(
                minHashes: 20,
                maxHashes: 100,
                ivBase64: 'QIfplaKKc+cXyDKWiNzNqw==',
                saltBase64: 'x/kuih9JOYNLW8IaFGhfi30/X9qbMjJHsvLWpkWZM6I=',
                random: Random(100),
              ),
        };

Map<String, UserAuthenticationGenerator Function()>
    get userAuthenticationGeneratorTestCases => {
          '1': () => UserAuthenticationGenerator(
                methodGenerator: methodEncryptDecryptTestCases['1-1']!(),
                passwordHasher: passwordHasherTestCases['1']!(),
              ),
          '2': () => UserAuthenticationGenerator(
                methodGenerator: methodEncryptDecryptTestCases['1-10']!(),
                passwordHasher: passwordHasherTestCases['2']!(),
              ),
          '3': () => UserAuthenticationGenerator(
                methodGenerator: methodEncryptDecryptTestCases['20-100']!(),
                passwordHasher: passwordHasherTestCases['3']!(),
              ),
          '4': () => UserAuthenticationGenerator(
                methodGenerator: methodEncryptDecryptTestCases['20-100']!(),
                passwordHasher: passwordHasherTestCases['4']!(),
              ),
        };

Map<String, Random Function()> get randomTestCases => {
      '120': () => Random(120),
      '1203012': () => Random(1203012),
      '-120': () => Random(-120),
      '28': () => Random(28),
      '90': () => Random(90),
    };

Map<String, PasswordHasher Function()> get passwordHasherTestCases => {
      '1': () => PasswordHasher(
            pepper: '12345678',
            random: Random(120),
          ),
      '2': () => PasswordHasher(
            pepper: 'aBcDeFgHiJkLmNoP',
            random: Random(28),
          ),
      '3': () => PasswordHasher(
            pepper: 'A1269PmnO',
            random: Random(12003),
          ),
      '4': () => PasswordHasher(
            pepper: '402',
            random: Random(402),
          ),
    };
