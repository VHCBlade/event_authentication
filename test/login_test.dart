import 'package:event_authentication/event_authentication.dart';
import 'package:event_db/event_db.dart';
import 'package:test/test.dart';

void main() {
  test('EmailLoginRequest', () {
    final request = EmailLoginRequest()
      ..email = 'cool'
      ..noExpiry = true
      ..password = 'great';

    final requestCopy = EmailLoginRequest()..copy(request);

    expect(request.email, requestCopy.email);
    expect(request.noExpiry, requestCopy.noExpiry);
    expect(request.password, requestCopy.password);

    request
      ..email = 'amazing'
      ..noExpiry = false
      ..password = 'astounding';
    requestCopy.copy(request);

    expect(request.email, requestCopy.email);
    expect(request.noExpiry, requestCopy.noExpiry);
    expect(request.password, requestCopy.password);
  });
}
