import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:event_authentication/src/authenticator/method.dart';
import 'package:tuple/tuple.dart';

const _saltCharacters =
    '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

/// Hashes passwords using a method (Look at [MethodEncryptDecrypt] for more
/// information) and a salt and [pepper]
class PasswordHasher {
  /// [pepper] is added all passwords that are hashed
  ///
  /// [random] allows you to change the seed used in the randomness or share
  /// it with other objects.
  PasswordHasher({required this.pepper, Random? random})
      : _random = random ?? Random();

  final Random _random;

  /// Added to all passwords that are hashed.
  final String pepper;

  /// Generates a new salt of [length] length
  String generateSalt({int length = 32}) {
    return List.generate(
      length,
      (index) => _saltCharacters[_random.nextInt(_saltCharacters.length)],
    ).join();
  }

  /// Separate the [method] into the passwordAppend step and the repetition step
  ///
  /// Returns a Tuple2 with item1 being the passwordAppend and item2 being the
  /// repetition count.
  Tuple2<String, int> separateMethod(String method) {
    final pattern = RegExp(r'([a-zA-Z]+)(\d+)');
    final match = pattern.firstMatch(method);

    if (match == null) {
      throw FormatException('Invalid input format: $method');
    }

    final passwordAppend = match.group(1)!;
    final repetitions = int.parse(match.group(2)!);

    return Tuple2(passwordAppend, repetitions);
  }

  /// Appends the [password], [salt], and [pepper] together based on the given
  /// [passwordAppend].
  String appendPassword({
    required String password,
    required String salt,
    required String passwordAppend,
  }) {
    var appendedPassword = '';
    for (final char in passwordAppend.split('')) {
      switch (char) {
        case 'P':
          appendedPassword += pepper;
          break;
        case 'B':
          appendedPassword += password;
          break;
        case 'S':
          appendedPassword += salt;
          break;
        default:
          throw ArgumentError('"$passwordAppend" is not in the right format.');
      }
    }
    return appendedPassword;
  }

  /// Hashes [toHash] a single time
  String individualHash(String toHash) {
    final dataBytes = utf8.encode(toHash);
    final hash = sha256.convert(dataBytes);
    return hash.toString();
  }

  /// Hashes [password] with [salt] and [pepper] using the given [method]
  String hash({
    required String password,
    required String salt,
    required String method,
  }) {
    final separatedMethod = separateMethod(method);
    final appendedPassword = appendPassword(
      password: password,
      salt: salt,
      passwordAppend: separatedMethod.item1,
    );

    var hashedPassword = appendedPassword;
    for (var i = 0; i < max(1, separatedMethod.item2); i++) {
      hashedPassword = individualHash(hashedPassword);
    }

    return hashedPassword;
  }
}
