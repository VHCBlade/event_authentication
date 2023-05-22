import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:event_authentication/src/authenticator/generator.dart';
import 'package:event_authentication/src/authenticator/hash.dart';
import 'package:event_authentication/src/authenticator/method.dart';
import 'package:event_bloc/event_bloc.dart';
import 'package:event_db/event_db.dart';
import 'package:tuple/tuple.dart';

/// Model that holds Authentication related secrets
class AuthenticationSecretsModel extends GenericModel {
  /// Pepper used in password hashing
  late String pepper;

  /// Cipher used for method encryption
  late String methodSalt64;

  /// Initialization Vector used for method encryption
  late String methodIv64;

  /// Minimum number of hashes for password hashing
  late int methodMinHashes;

  /// Maximum number of hashes for password hashing
  late int methodMaxHashes;

  @override
  Map<String, Tuple2<Getter<dynamic>, Setter<dynamic>>> getGetterSetterMap() =>
      {
        'pepper': Tuple2(() => pepper, (val) => pepper = '$val'),
        'methodSalt64':
            Tuple2(() => methodSalt64, (val) => methodSalt64 = '$val'),
        'methodIv64': Tuple2(() => methodIv64, (val) => methodIv64 = '$val'),
        'methodMinHashes': Tuple2(
          () => methodMinHashes,
          (val) => methodMinHashes = val as int,
        ),
        'methodMaxHashes': Tuple2(
          () => methodMaxHashes,
          (val) => methodMaxHashes = val as int,
        ),
      };

  @override
  String get type => 'AuthenticationSecretsModel';
}

/// Repository to access secrets for the Authenticator
abstract class AuthenticationSecretsRepository extends Repository {
  /// Retrieves the secrets from a potentially secure place.
  FutureOr<AuthenticationSecretsModel> get secrets;

  /// Retrieves the jwt secret from a potentially secure place.
  FutureOr<String> get jwtSecret;

  /// Clears any secrets that have been set.
  ///
  /// YOU SHOULD BE VERY CAREFUL WHEN CALLING THIS
  FutureOr<void> clearSecrets();

  /// Specified iff a specific random seed is necessary such as in tests
  Random? get random;
}

/// Adds Authentication Object Generators to AuthenticationSecretsRepository
extension AuthenticationSecretsRepositoryRepositoryGenerator
    on AuthenticationSecretsRepository {
  /// Creates a [UserAuthenticationGenerator] based on the result of [secrets]
  Future<UserAuthenticationGenerator> get generator async {
    final loadedSecrets = await secrets;

    return UserAuthenticationGenerator(
      methodGenerator: MethodEncryptDecrypt(
        ivBase64: loadedSecrets.methodIv64,
        saltBase64: loadedSecrets.methodSalt64,
        maxHashes: loadedSecrets.methodMaxHashes,
        minHashes: loadedSecrets.methodMinHashes,
        random: random,
      ),
      passwordHasher: PasswordHasher(
        pepper: loadedSecrets.pepper,
        random: random,
      ),
    );
  }
}

/// Stores secrets inside of a file. Automatically generates the secrets file if
/// it doesn't exist.
class FileSecretsRepository extends AuthenticationSecretsRepository {
  /// [secretsFile] is the path to where the secrets file can be found and
  /// stored.
  FileSecretsRepository({
    required this.secretsFile,
    this.random,
  });

  /// the path to where the secrets file can be found and stored.
  final String secretsFile;

  String get _jwtSecretsFile => '$secretsFile.jwt';

  @override
  final Random? random;

  @override
  List<BlocEventListener<dynamic>> generateListeners(
    BlocEventChannel channel,
  ) =>
      [];

  @override
  void clearSecrets() {
    try {
      File(secretsFile).deleteSync();
    } on FileSystemException {
      // just go on
    }

    try {
      File(_jwtSecretsFile).deleteSync();
    } on FileSystemException {
      return;
    }
  }

  @override
  Future<String> get jwtSecret async {
    final file = File(_jwtSecretsFile);
    if (file.existsSync()) {
      return file.readAsStringSync();
    }

    file.createSync(recursive: true);
    final myRandom = random ?? Random.secure();
    final hasher = PasswordHasher(pepper: '', random: myRandom);
    final secret = hasher.generateSalt(length: myRandom.nextInt(32) + 64);
    file.writeAsStringSync(secret);
    return secret;
  }

  @override
  Future<AuthenticationSecretsModel> get secrets async {
    final file = File(secretsFile);
    if (file.existsSync()) {
      final map = json.decode(file.readAsStringSync()) as Map<String, dynamic>;
      final model = AuthenticationSecretsModel()..loadFromMap(map);

      return model;
    }

    file.createSync(recursive: true);
    final myRandom = random ?? Random.secure();
    final hasher = PasswordHasher(pepper: '', random: myRandom);
    final ivBase64 = IV(
      Uint8List.fromList(
        List.generate(16, (i) => myRandom.nextInt(256)),
      ),
    ).base64;
    final saltBase64 = IV(
      Uint8List.fromList(
        List.generate(32, (i) => myRandom.nextInt(256)),
      ),
    ).base64;

    final newModel = AuthenticationSecretsModel()
      ..methodMinHashes = myRandom.nextInt(200) + 100
      ..methodMaxHashes = myRandom.nextInt(200) + 600
      ..pepper = hasher.generateSalt(length: myRandom.nextInt(32) + 64)
      ..methodIv64 = ivBase64
      ..methodSalt64 = saltBase64;

    file.writeAsStringSync(json.encode(newModel.toMap()));

    return newModel;
  }
}
