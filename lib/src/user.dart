import 'package:event_authentication/event_authentication.dart';
import 'package:event_db/event_db.dart';
import 'package:tuple/tuple.dart';

/// The model that defines and holds important information about your user.
///
/// This shouldn't be extended, and should instead
class UserModel extends GenericModel {
  /// The optional username used to login in place of an email
  String? username;

  /// The email of the user.
  ///
  /// This may be used to login.
  String? email;

  /// The roles assigned to this [UserModel].
  ///
  /// This should be used in client and server side authentication for
  /// User Access Controln
  JWTRole roles = JWTRole();

  @override
  Map<String, Tuple2<Getter<dynamic>, Setter<dynamic>>> getGetterSetterMap() =>
      {
        'username':
            Tuple2(() => username, (value) => username = value as String?),
        'email': Tuple2(() => email, (value) => email = value as String?),
        'roles': GenericModel.model(
          () => roles,
          (value) => roles = value ?? JWTRole(),
          JWTRole.new,
        ),
      };

  @override
  String get type => 'User';
}

/// Separate object to store the user's authentication credentials
///
/// Set the [idSuffix] of this to be equal to the id of the [UserModel]
class UserAuthentication extends GenericModel {
  /// This is the hashed version of the base password
  late String password;

  /// This is added to the base password to increase the security in case of DB
  /// acquisition.
  late String salt;

  /// This contains a String that should map into an environment variable that
  /// has instructions about how to check the password.
  late String method;

  /// The id of the [UserModel] this authentication is for.
  String? get userId => id?.replaceFirst(prefixTypeForId(''), '');
  set userId(String? newId) => idSuffix = newId;

  @override
  Map<String, Tuple2<Getter<dynamic>, Setter<dynamic>>> getGetterSetterMap() =>
      {
        'password': GenericModel.primitive(
          () => password,
          (value) => password = '$value',
        ),
        'salt': GenericModel.primitive(
          () => salt,
          (value) => salt = '$value',
        ),
        'method': GenericModel.primitive(
          () => method,
          (value) => method = '$value',
        ),
      };

  @override
  String get type => 'UserAuthentication';
}
