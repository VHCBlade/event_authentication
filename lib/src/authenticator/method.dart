import 'dart:math';

import 'package:encrypt/encrypt.dart';

const _configurations = ['SBP', 'SPB', 'PBS', 'PSB', 'BSP', 'BPS'];
final _methodRegex = RegExp(r'^[BSP]{3,}\d+$');

/// Exception thrown when a method is expected but not provided in a correct
/// format
class NotMethodException implements Exception {
  /// An exception saying that [method] is not valid when it should be
  const NotMethodException({required this.method, this.encrypted = false});

  /// The method String that caused the error
  final String method;

  /// Whether [method] is encrypted or not
  final bool encrypted;
}

/// Used to encrypt and decrypt the method used in hashing passwords.
class MethodEncryptDecrypt {
  /// [minHashes] and [maxHashes] sets the random number of possible hashes
  ///
  /// [saltBase64] is used as a cipher when encrypting the method value
  ///
  /// [ivBase64] is an initialization vector used in encryption
  ///
  /// [random] allows you to change the seed used in the randomness or share
  /// it with other objects.
  MethodEncryptDecrypt({
    required this.minHashes,
    required this.maxHashes,
    required this.saltBase64,
    required this.ivBase64,
    Random? random,
  }) : _random = random ?? Random();

  final Random _random;

  /// Represents the inclusive minimum number of hashes for the generated
  /// methods
  final int minHashes;

  /// Represents the inclusive maximum number of hashes for the generated
  /// methods
  final int maxHashes;

  /// Represents a salt that's used as a cipher for the encrypted method
  final String saltBase64;

  /// Represents an initialization vector that's used as a cipher for the
  /// encrypted method
  final String ivBase64;

  /// Generates a random valid unencrypted method within [minHashes] and
  /// [maxHashes]
  String generateMethod() {
    final baseConfiguration =
        _configurations[_random.nextInt(_configurations.length)];

    final hashCount = minHashes + _random.nextInt(maxHashes - minHashes + 1);

    return '$baseConfiguration$hashCount';
  }

  /// Same as [generateMethod] except it immediately calls [encryptMethod]
  /// before returning.
  String generateEncryptedMethod() {
    final method = generateMethod();
    return encryptMethod(method);
  }

  /// Checks whether [method] is a valid method or not.
  bool isMethod(String method) {
    return _methodRegex.hasMatch(method);
  }

  /// Checks that [method] is valid, then encrypts it using [saltBase64]
  /// and [ivBase64]
  ///
  /// throws a [NotMethodException] if [method] is not a method
  String encryptMethod(String method) {
    if (!isMethod(method)) {
      throw NotMethodException(method: method);
    }
    final encrypter = Encrypter(AES(Key.fromBase64(saltBase64)));
    final reversedMethod =
        method.split('').reversed.reduce((value, element) => '$value$element');

    return encrypter
        .encrypt('$reversedMethod$method', iv: IV.fromBase64(ivBase64))
        .base64;
  }

  /// Decrypts the [method] using [saltBase64] as a cipher, then checks that
  /// its valid
  ///
  /// throws a [NotMethodException] if [method] is not a method and
  /// [checkMethodValid] is true
  String decryptMethod(String method, {bool checkMethodValid = true}) {
    final decrypter = Encrypter(AES(Key.fromBase64(saltBase64)));
    final decryptedMethodDoubled = decrypter.decrypt(
      Encrypted.from64(method),
      iv: IV.fromBase64(ivBase64),
    );
    final decryptedMethod =
        decryptedMethodDoubled.substring(decryptedMethodDoubled.length ~/ 2);

    if (checkMethodValid) {
      if (!isMethod(decryptedMethod)) {
        throw NotMethodException(method: method, encrypted: true);
      }
    }
    return decryptedMethod;
  }
}
