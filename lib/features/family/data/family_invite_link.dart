import 'family_crypto.dart';

/// A family invite link:
/// `https://lifethreads.gkcoding.dev/family/join#t=<token>&f=<familyId>&k=<key>`.
///
/// Everything sits in the URL fragment, which browsers and HTTP clients never
/// send to a server. Only [token] is ever sent to the API (to accept the
/// invite); the family key [key] stays on the device.
class FamilyInviteLink {
  const FamilyInviteLink({
    required this.token,
    required this.familyId,
    required this.key,
  });

  static const host = 'lifethreads.gkcoding.dev';
  static const path = '/family/join';

  static final _tokenPattern = RegExp(r'^lti_[A-Za-z0-9_-]{32}$');
  static final _familyIdPattern = RegExp(r'^[A-Za-z0-9_-]{16,64}$');

  final String token;
  final String familyId;
  final FamilyKey key;

  /// Appends the key to the server's invite URL (which already carries
  /// `t` and `f` in its fragment).
  static Uri withKey(String serverInviteUrl, FamilyKey key) {
    final base = Uri.parse(serverInviteUrl);
    final params = Uri.splitQueryString(base.fragment);
    final token = params['t'];
    final familyId = params['f'];
    if (token == null || familyId == null) {
      throw const FormatException('The invite URL has no token.');
    }
    return FamilyInviteLink(
      token: token,
      familyId: familyId,
      key: key,
    ).toUri(scheme: base.scheme, host: base.host, port: base.port);
  }

  Uri toUri({String scheme = 'https', String host = host, int? port}) {
    return Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: path,
      fragment: 't=$token&f=$familyId&k=${key.encode()}',
    );
  }

  /// Parses an invite link, or returns null for anything else (other
  /// paths, missing or malformed parameters, a key of the wrong size).
  static FamilyInviteLink? tryParse(Uri link) {
    if (link.scheme != 'https' || link.host != host) return null;
    final linkPath = link.path.endsWith('/')
        ? link.path.substring(0, link.path.length - 1)
        : link.path;
    if (linkPath != path) return null;
    final Map<String, String> params;
    try {
      params = Uri.splitQueryString(link.fragment);
    } on FormatException {
      return null;
    }
    final token = params['t'];
    final familyId = params['f'];
    final rawKey = params['k'];
    if (token == null || !_tokenPattern.hasMatch(token)) return null;
    if (familyId == null || !_familyIdPattern.hasMatch(familyId)) return null;
    final key = rawKey == null ? null : FamilyKey.tryParse(rawKey);
    if (key == null) return null;
    return FamilyInviteLink(token: token, familyId: familyId, key: key);
  }
}
