import 'package:event_authentication/event_authentication.dart';
import 'package:event_authentication/src/authenticator/db/secrets.dart';
import 'package:event_authentication/src/authenticator/generator.dart';
import 'package:event_db/event_db.dart';

/// Exception thrown if [DatabaseUserAuthenticator] interacts with an
/// idless [UserModel]
class UserModelIDException implements Exception {
  /// Const Constructor
  const UserModelIDException();

  @override
  String toString() {
    return 'UserModel needs to have an id before creating'
        ' an Authentication for it.';
  }
}

/// Uses a [DatabaseRepository] and a [UserAuthenticationGenerator]
/// to automatically create and verify users.
class DatabaseUserAuthenticator {
  /// [database], [authenticationDatabase] are both used to
  /// determine where to save and find the stored [UserAuthentication]
  ///
  /// [authenticationGenerator] handles the generation and authentication
  /// of [UserAuthentication]s
  ///
  /// [secretsRepository]
  DatabaseUserAuthenticator({
    required this.database,
    required this.authenticationDatabase,
    required this.authenticationGenerator,
    required this.secretsRepository,
  });

  /// The [DatabaseRepository] where the [UserAuthentication]s will be stored
  final DatabaseRepository database;

  SpecificDatabase get _specificDatabase =>
      SpecificDatabase(database, authenticationDatabase);

  /// The name of the database where the [UserAuthentication]s will be stored
  final String authenticationDatabase;

  /// Generates and Authenticates [UserAuthentication]s with and against the
  /// base Passwords
  final UserAuthenticationGenerator authenticationGenerator;

  /// Holds and can automatically generate the [AuthenticationSecretsModel]
  /// needed for the hashing part of this
  final AuthenticationSecretsRepository secretsRepository;

  /// Saves a new [UserAuthentication] for the given [model] with [basePassword]
  /// as the way to confirm it.
  Future<void> saveUserAuthentication(
    UserModel model,
    String basePassword,
  ) async {
    if (model.id == null) {
      throw const UserModelIDException();
    }
    final authentication = authenticationGenerator
        .generateAuthentication(basePassword)
      ..userId = model.id;
    await _specificDatabase.saveModel(authentication);
  }

  /// Confirms if the given [basePassword] is the correct password for the
  /// given [model].
  Future<bool> confirmPassword(
    UserModel model,
    String basePassword,
  ) async {
    final authentication = await findUserAuthentication(model);
    if (authentication == null) {
      return false;
    }
    return authenticationGenerator.confirmAuthentication(
      authentication,
      basePassword,
    );
  }

  /// Finds the [UserAuthentication] for the given [model] if it exists in
  /// [authenticationDatabase]
  Future<UserAuthentication?> findUserAuthentication(UserModel model) async {
    if (model.id == null) {
      throw const UserModelIDException();
    }
    final authenticationId = (UserAuthentication()..userId = model.id).id!;
    return await _specificDatabase.findModel(authenticationId);
  }

  /// Deletes the [UserAuthentication] for the given [model] if it exists in
  /// [authenticationDatabase]
  Future<bool> deleteUserAuthentication(UserModel model) async {
    final authentication = await findUserAuthentication(model);
    if (authentication == null) {
      return false;
    }
    return await _specificDatabase.deleteModel(authentication);
  }
}
