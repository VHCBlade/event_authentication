import 'dart:async';

import 'package:event_authentication/event_authentication.dart';

/// Holds information on how to create and sign JWTs
class JWTSigner {
  /// [_secret] is the function used to get the secret for signing the JWTs
  JWTSigner(this._secret);

  final FutureOr<String> Function() _secret;

  String createToken(BaseJWT baseJWT) {
    return '';
  }
}
