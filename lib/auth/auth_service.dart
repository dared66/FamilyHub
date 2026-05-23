import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Holds the authentication result returned by [AuthService.getAuth].
class GoogleAuthResult {
  final String accessToken;
  final DateTime expiryTime;

  const GoogleAuthResult({
    required this.accessToken,
    required this.expiryTime,
  });
}

/// Manages Google sign-in state and token retrieval for FamilyHub.
class AuthService {
  static const String _userIdKey = 'familyhub_user_id';

  final GoogleSignIn _googleSignIn;
  final FlutterSecureStorage _secureStorage;

  AuthService({
    GoogleSignIn? googleSignIn,
    FlutterSecureStorage? secureStorage,
  })  : _googleSignIn = googleSignIn ?? GoogleSignIn(
          scopes: const [
            'email',
            'openid',
            'https://www.googleapis.com/auth/calendar',
            'https://www.googleapis.com/auth/tasks',
            'https://www.googleapis.com/auth/photoslibrary.readonly',
          ],
        ),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  GoogleSignIn get googleSignIn => _googleSignIn;
  FlutterSecureStorage get secureStorage => _secureStorage;

  /// Streams the current auth state.
  Stream<GoogleSignInAccount?> get onAuthChanged =>
      _googleSignIn.onCurrentUserChanged;

  /// Returns true if a Google account is currently signed in.
  Future<bool> isSignedIn() async {
    try {
      return await _googleSignIn.isSignedIn();
    } catch (e) {
      debugPrint('Error checking sign-in state: $e');
      return false;
    }
  }

  /// Initiates the Google Sign-In UI.
  Future<GoogleSignInAccount?> signIn() async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      final account = await _googleSignIn.signIn();
      if (account != null) {
        await _secureStorage.write(
          key: _userIdKey,
          value: account.id ?? '',
        );
      }
      return account;
    } catch (e) {
      debugPrint('Google sign-in exception: $e');
      return null;
    }
  }

  /// Attempts a silent sign-in.
  Future<GoogleSignInAccount?> signInSilently() async {
    try {
      return await _googleSignIn.signInSilently();
    } catch (e) {
      debugPrint('Sign-in silently failed: $e');
      return null;
    }
  }

  /// Signs out the user.
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _secureStorage.delete(key: _userIdKey);
    } catch (e) {
      debugPrint('Sign-out error: $e');
    }
  }

  /// Revokes authorization and signs out.
  Future<void> revoke() async {
    try {
      await _googleSignIn.disconnect();
    } catch (e) {
      debugPrint('Revoke error, falling back: $e');
    }
    await signOut();
  }

  /// Returns the access token for API calls.
  Future<String?> getAccessToken() async {
    try {
      var account = _googleSignIn.currentUser;
      if (account == null) {
        account = await _googleSignIn.signInSilently();
      }
      if (account == null) return null;
      final auth = await account.authentication;
      return auth.accessToken;
    } catch (e) {
      debugPrint('Get access token error: $e');
      return null;
    }
  }

  /// Convenience: returns a header map for Google API calls.
  Future<Map<String, String>> authHeaders() async {
    final token = await getAccessToken();
    if (token == null) return {};
    return {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
  }

  /// Gets the current account, with silent sign-in fallback.
  Future<GoogleSignInAccount?> getCurrentAccount() async {
    try {
      var account = _googleSignIn.currentUser;
      if (account == null) {
        account = await _googleSignIn.signInSilently();
      }
      return account;
    } catch (e) {
      debugPrint('Error getting current account: $e');
      return null;
    }
  }
}
