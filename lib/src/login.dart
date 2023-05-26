import 'package:event_db/event_db.dart';
import 'package:tuple/tuple.dart';

/// Represents an email login
class EmailLoginRequest extends GenericModel {
  /// The email of the user to be logged in
  late String email;

  /// The password of the user to be logged in
  late String password;

  /// For a login that wishes to set an expiration indefinitely
  /// such as for mobile.
  bool noExpiry = false;

  @override
  Map<String, Tuple2<Getter<dynamic>, Setter<dynamic>>> getGetterSetterMap() =>
      {
        'email': Tuple2(() => email, (val) => email = val as String),
        'password': Tuple2(() => password, (val) => password = val as String),
        'lateExpiry': Tuple2(
          () => noExpiry,
          (val) => noExpiry = val as bool? ?? false,
        ),
      };

  @override
  String get type => 'Email Login';
}
