import 'package:test/test.dart';

import 'user/confirm.dart' as confirm;
import 'user/save_user.dart' as save_user;

void main() {
  group('DatabaseUserAuthenticator', () {
    group('saveUserAuthentication', () {
      group('Basic', save_user.basicTest);
      group('IdException', save_user.idExceptionTest);
    });
    group('confirmPassword', () {
      group('Basic', confirm.basicTest);
      group('IdException', confirm.idExceptionTest);
      group('Delete', confirm.deleteTest);
    });
  });
}
