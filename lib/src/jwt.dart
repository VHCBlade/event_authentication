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
