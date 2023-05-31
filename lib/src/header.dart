/// Adds header methods for passing into requests or responses
extension HeaderExtension on Map<String, Object> {
  /// Sets the [token] into the Authrorization header
  set authorization(String? token) {
    remove('Authorization');
    remove('authorization');
    if (token != null) {
      this['Authorization'] = 'Bearer $token';
    }
  }

  String? _getAuthorization(String key) => this[key] == null
      ? null
      : '${this[key]}'.startsWith('Bearer ')
          ? '${this[key]}'.substring('Bearer '.length)
          : '${this[key]}';

  /// Gets the JWT Token from the Authorization header
  String? get authorization =>
      _getAuthorization('Authorization') ?? _getAuthorization('authorization');
}
