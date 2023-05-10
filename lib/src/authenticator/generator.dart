import 'package:event_authentication/event_authentication.dart';

import 'package:event_authentication/src/authenticator/method.dart';

/// Generates a User Authentication Object
class UserAuthenticationGenerator {
  /// [methodGenerator] used to generate the method field of
  /// generated [UserAuthentication]s
  UserAuthenticationGenerator({
    required this.methodGenerator,
  });

  /// Used to generate the method field of generated [UserAuthentication]s
  final MethodEncryptDecrypt methodGenerator;

  /// Generates a [UserAuthentication] with the [basePassword] as the key to
  /// pass the authentication.
  UserAuthentication generateAuthentication(String basePassword) {
    final authentication = UserAuthentication();
    final method = methodGenerator.generateMethod();

    authentication.method = methodGenerator.encryptMethod(method);

    return authentication;
  }
}
