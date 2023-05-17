import 'package:event_authentication/src/authenticator/db/secrets.dart';
import 'package:event_authentication/src/authenticator/generator.dart';
import 'package:event_db/event_db.dart';

/// Uses a [DatabaseRepository] and a [UserAuthenticationGenerator]
/// to automatically create and verify users.
class DatabaseUserAuthenticator {
  /// [repository], [userDatabase], [authenticationDatabase] are all used to
  /// determine where to save and find the information
  DatabaseUserAuthenticator({
    required this.repository,
    required this.userDatabase,
    required this.authenticationDatabase,
    required this.authenticationGenerator,
    required this.secretsLocation,
  });

  final DatabaseRepository repository;
  final UserAuthenticationGenerator authenticationGenerator;
  final String userDatabase;
  final String authenticationDatabase;
  final AuthenticationSecretsRepository secretsLocation;
}
