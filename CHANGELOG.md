## 0.1.5

- Added createNonStandardToken to JWTSigner

## 0.1.4

- Updated event_db and event_db_tester to also accept the new 0.2.0 version
- Added TODO.md

## 0.1.3+1

- Fixed Issue where authorization wouldn't work correctly if the header key was all lower case.
- Added login_test

## 0.1.3

- Added HeaderExtension

## 0.1.2+1

- Renamed Exceptions to avoid collisions
- Upgraded to dart_jsonwebtoken 2.8.0

## 0.1.1+2

- Changed noExpiry to have a default value in EmailLoginRequest

## 0.1.1+1

- Added event_authentication to exported libraries of event_authenticator
- Added BaseJWT.fromToken method

## 0.1.1

- Added JWTSigner
- Added noExpiry field that defaults to false to EmailLoginRequest
- Added jwtSecret to AuthenticationSecretsRepository

## 0.1.0+1

- Added login.dart to exports in event_authentication

## 0.1.0

- Initial version.
