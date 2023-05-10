import 'dart:math';

import 'package:event_authentication/src/authenticator/hash.dart';
import 'package:event_authentication/src/authenticator/method.dart';

Map<String, List<String> Function()> get methodTestCases => {
      'Standard': () =>
          ['PSB89', 'PBS102310', 'BSP1000', 'SPB1', 'SBP100', 'BPS601'],
      'More': () => ['PPSB10', 'SBPPBS10203', 'SSBP1', 'SSSPB102', 'SSP21'],
      'Fake': () =>
          ['10PSB10', 'PBS', 'BS120', 'B1', '', 'PSB', 'psb102', 'ABC102'],
      'Zero': () => ['PSB0', 'PBS0', 'BSP000', 'SPB0', 'SBP00', 'BPS0'],
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
