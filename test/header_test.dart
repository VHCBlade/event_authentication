import 'package:event_authentication/event_authentication.dart';
import 'package:test/test.dart';

void main() {
  group('HeaderExtension', () {
    test('Authorization', () {
      final map = <String, Object>{}..authorization = 'myToken';
      expect(map.authorization, 'myToken');
      expect(map, {'Authorization': 'Bearer myToken'});
      map.authorization = null;

      expect(map.authorization, null);
      expect(map, <String, Object>{});

      map['Authorization'] = 'Amazing';
      expect(map.authorization, 'Amazing');
      expect(map, {'Authorization': 'Amazing'});
    });
    test('Lowercase Authorization', () {
      final map = <String, Object>{};

      map['authorization'] = 'Amazing';
      expect(map.authorization, 'Amazing');
      expect(map, {'authorization': 'Amazing'});

      map.authorization = null;
      expect(map.authorization, null);
      expect(map, <String, Object>{});
    });
  });
}
