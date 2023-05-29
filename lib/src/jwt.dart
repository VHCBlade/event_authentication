import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:event_authentication/event_authentication.dart';
import 'package:event_db/event_db.dart';
import 'package:tuple/tuple.dart';

/// All the Models related to JWTs
const jwtRoles = {JWTRole, BaseJWT};

/// This contains the roles that have been allocated for a [BaseJWT]
///
/// Use this to verify Control Access in your client and server side!
class JWTRole extends GenericModel {
  /// This contains all the roles that are available to a user with
  /// this [JWTRole].
  List<String> roles = [];

  /// Checks to see if [role] is contained in the [roles] of this
  /// [JWTRole]
  bool containsRole(String role) => roles.contains(role);

  /// Checks to see if any of the [roles] are contained in this [JWTRole]
  bool containsAnyRoles(List<String> roles) =>
      roles.any((element) => this.roles.contains(element));

  @override
  Map<String, Tuple2<Getter<dynamic>, Setter<dynamic>>> getGetterSetterMap() =>
      {
        'roles': Tuple2(
          () => roles,
          (val) => roles = (val as List?)?.map((e) => '$e').toList() ?? [],
        ),
      };

  @override
  String get type => 'JWTRole';
}

/// This is the Base JWT Model for your authentication. You can extend this to
/// add more data if necessary, however you can use this as is.
class BaseJWT extends GenericModel {
  /// Default Constructor
  BaseJWT();

  /// Creates a base jwt from a [userModel].
  ///
  /// [duration] will set the [expiry] value to the given value automatically.
  /// You can still edit this afterwards.
  factory BaseJWT.fromUserModel(
    UserModel userModel, {
    Duration duration = const Duration(hours: 2),
  }) =>
      BaseJWT()
        ..id = userModel.id
        ..dateIssued = DateTime.now()
        ..expiry = duration
        ..jwtRole = (JWTRole()..copy(userModel.roles));

  /// Creates a base jwt from the given [token].
  ///
  /// Does not check if the underlying token is valid or not.
  factory BaseJWT.fromToken(String token) {
    late final JWT jwt;
    try {
      jwt = JWT.decode(token);
    } on FormatException {
      throw EventJWTInvalidException('Token format is incorrect!');
    }

    if (jwt.payload is! Map<String, dynamic>) {
      throw EventJWTInvalidException(
        'JWT does not contain a proper BaseJWT as its payload!',
      );
    }

    final baseJWT = BaseJWT()..loadFromMap(jwt.payload as Map<String, dynamic>);
    return baseJWT;
  }

  /// When this [BaseJWT] was issued. This is combined with expiry to determine
  /// if a JWT has expired.
  DateTime dateIssued = DateTime.now();

  /// When this [BaseJWT] will expire after it has been issued.
  ///
  /// This starts at no duration, so make sure you set the expiry
  /// before using this!
  Duration expiry = Duration.zero;

  /// Checks the time now against [dateIssued] and [expiry] to see if this token
  /// is expired.
  bool get isExpired => DateTime.now().isAfter(dateIssued.add(expiry));

  /// The roles that have been allocated for this [BaseJWT].
  JWTRole jwtRole = JWTRole();

  @override
  Map<String, Tuple2<Getter<dynamic>, Setter<dynamic>>> getGetterSetterMap() =>
      {
        'dateIssued': GenericModel.dateTime(
          () => dateIssued,
          (value) => dateIssued = value!,
        ),
        'role': GenericModel.model(
          () => jwtRole,
          (value) => jwtRole = value!,
          JWTRole.new,
        ),
        'expiry': Tuple2(
          () => expiry.inMilliseconds,
          (value) => expiry = Duration(milliseconds: value as int),
        ),
      };

  @override
  String get type => 'BaseJWT';
}
