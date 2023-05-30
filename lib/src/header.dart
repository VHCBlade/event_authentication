/// Adds header methods for passing into requests or responses
extension HeaderExtension on Map<String, Object> {
  /// Sets the [token] into the Authrorization header
  set authorization(String? token) => token == null
      ? remove('Authorization')
      : this['Authorization'] = 'Bearer $token';

  /// Gets the JWT Token from the Authorization header
  String? get authorization => this['Authorization'] == null
      ? null
      : "${this['Authorization']}".startsWith('Bearer ')
          ? "${this['Authorization']}".substring('Bearer '.length)
          : "${this['Authorization']}";
}
