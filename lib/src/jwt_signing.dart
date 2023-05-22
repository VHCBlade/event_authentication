import 'dart:async';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:event_authentication/event_authentication.dart';

/// An exception thrown when a jwt has already expired.
class JWTExpiredException implements Exception {}

/// An exception thrown when a jwt isn't signed correctly or is otherwise
/// invalid.
class JWTInvalidException implements Exception {
  /// [message] gives extra information about why the exception happened.
  JWTInvalidException(this.message);

  /// gives extra information about why the exception happened.
  final String message;
}

/// Holds information on how to create and sign JWTs
class JWTSigner {
  /// [_secret] is the function used to get the secret for signing the JWTs
  JWTSigner(this._secret, {required this.issuer});

  /// The website you are using to issue JWTs from here. This should be
  /// consistent as this is checked later to ensure the JWT is valid.
  final String issuer;

  final FutureOr<String> Function() _secret;

  /// Creates a token from a [baseJWT] to be placed in the Authorization
  /// header.
  Future<String> createToken(BaseJWT baseJWT) async {
    final jwt = JWT(baseJWT.toMap(), issuer: issuer);
    final secret = await _secret();
    return jwt.sign(SecretKey(secret));
  }

  /// Validates that the given [token] is signed correctly and then returns
  /// the corresponding [BaseJWT]
  Future<BaseJWT> validateAndDecodeToken(String token) async {
    final secret = await _secret();
    late final JWT jwt;
    try {
      jwt = JWT.verify(token, SecretKey(secret));

      // ignore: avoid_catching_errors
    } on JWTExpiredError {
      throw JWTExpiredException();
      // ignore: avoid_catching_errors
    } on JWTError catch (e) {
      throw JWTInvalidException(e.message);
    } on FormatException {
      throw JWTInvalidException('Token format is incorrect!');
    }

    if (jwt.payload is! Map<String, dynamic>) {
      throw JWTInvalidException(
        'JWT does not contain a proper BaseJWT as its payload!',
      );
    }
    if (jwt.issuer != issuer) {
      throw JWTInvalidException('JWT Issuer does not match!');
    }

    final baseJWT = BaseJWT()..loadFromMap(jwt.payload as Map<String, dynamic>);
    if (baseJWT.isExpired) {
      throw JWTExpiredException();
    }
    return baseJWT;
  }
}
