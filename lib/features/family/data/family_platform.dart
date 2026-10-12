import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/store_kit_2_wrappers.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../premium/domain/premium_product.dart';
import '../domain/family_models.dart';
import 'family_api_client.dart';

/// An ID token from Apple or Google, plus the raw nonce the server checks.
class FamilyIdentityToken {
  const FamilyIdentityToken({required this.idToken, this.nonce});

  final String idToken;
  final String? nonce;
}

/// Native sign-in, behind an interface so tests need no platform channels.
abstract interface class FamilyIdentityProvider {
  Future<FamilyIdentityToken> signInWithApple();
  Future<FamilyIdentityToken> signInWithGoogle();

  /// Forgets the provider-side session (Google account picker state).
  Future<void> signOut();
}

/// Sign in with Apple (iOS, native) and Google (Android and iOS).
///
/// Client ids come from `--dart-define`s; none is a secret:
/// - `LIFETHREADS_GOOGLE_SERVER_CLIENT_ID`: the Google "Web application"
///   OAuth client id. Android needs it (it becomes the ID token audience).
/// - `LIFETHREADS_GOOGLE_IOS_CLIENT_ID`: the Google "iOS" OAuth client id
///   (or `GIDClientID` in Info.plist).
///
/// Apple sign-in needs no client id on iOS (the bundle id is the audience).
/// Android has no native Apple sign-in; the web flow would need a server
/// callback the family API does not have, so Android offers Google only.
class PlatformFamilyIdentityProvider implements FamilyIdentityProvider {
  PlatformFamilyIdentityProvider({
    this.googleServerClientId = const String.fromEnvironment(
      'LIFETHREADS_GOOGLE_SERVER_CLIENT_ID',
    ),
    this.googleIosClientId = const String.fromEnvironment(
      'LIFETHREADS_GOOGLE_IOS_CLIENT_ID',
    ),
  });

  final String googleServerClientId;
  final String googleIosClientId;
  Future<void>? _googleInit;

  static bool get supportsApple =>
      !kIsWeb && (Platform.isIOS || Platform.isMacOS);

  @override
  Future<FamilyIdentityToken> signInWithApple() async {
    if (!supportsApple || !await SignInWithApple.isAvailable()) {
      throw const FamilyException(
        FamilyErrorCodes.signInUnavailable,
        'Sign in with Apple is not available on this device.',
      );
    }
    // Apple embeds SHA-256(nonce) in the token; the server gets the raw
    // nonce and checks the hash, so a captured token cannot be replayed.
    final nonce = _randomNonce();
    final hashed = await Sha256().hash(utf8.encode(nonce));
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: const [],
        nonce: _hex(hashed.bytes),
      );
      final token = credential.identityToken;
      if (token == null) {
        throw const FamilyException(FamilyErrorCodes.signInUnavailable);
      }
      return FamilyIdentityToken(idToken: token, nonce: nonce);
    } on SignInWithAppleAuthorizationException catch (error) {
      if (error.code == AuthorizationErrorCode.canceled) {
        throw const FamilyException(FamilyErrorCodes.signInCanceled);
      }
      throw FamilyException(FamilyErrorCodes.signInUnavailable, error.message);
    } on SignInWithAppleException catch (error) {
      throw FamilyException(
        FamilyErrorCodes.signInUnavailable,
        error.toString(),
      );
    }
  }

  @override
  Future<FamilyIdentityToken> signInWithGoogle() async {
    final google = GoogleSignIn.instance;
    // initialize() may run only once per app run, so no per-sign-in nonce
    // for Google; the server's audience, issuer and expiry checks apply.
    await (_googleInit ??= google.initialize(
      clientId: googleIosClientId.isEmpty || !Platform.isIOS
          ? null
          : googleIosClientId,
      serverClientId: googleServerClientId.isEmpty
          ? null
          : googleServerClientId,
    ));
    if (!google.supportsAuthenticate()) {
      throw const FamilyException(FamilyErrorCodes.signInUnavailable);
    }
    try {
      final account = await google.authenticate();
      final token = account.authentication.idToken;
      if (token == null) {
        throw const FamilyException(FamilyErrorCodes.signInUnavailable);
      }
      return FamilyIdentityToken(idToken: token);
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw const FamilyException(FamilyErrorCodes.signInCanceled);
      }
      throw FamilyException(
        FamilyErrorCodes.signInUnavailable,
        error.description,
      );
    }
  }

  @override
  Future<void> signOut() async {
    if (_googleInit == null) return;
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // Signing out of Google is best effort.
    }
  }

  static String _randomNonce() {
    final random = Random.secure();
    return base64Url
        .encode(List<int>.generate(32, (_) => random.nextInt(256)))
        .replaceAll('=', '');
  }

  static String _hex(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

/// The store purchase the server verifies.
class FamilyStorePurchase {
  const FamilyStorePurchase.google(String purchaseToken)
    : platform = 'google',
      token = purchaseToken;

  const FamilyStorePurchase.apple(String originalTransactionId)
    : platform = 'apple',
      token = originalTransactionId;

  final String platform;
  final String token;

  Map<String, Object?> toJson() => {
    'platform': platform,
    if (platform == 'apple') 'transactionId': token else 'purchaseToken': token,
  };
}

abstract interface class FamilyPurchaseSource {
  /// The Premium subscription purchase on this device, or null.
  Future<FamilyStorePurchase?> premiumPurchase();
}

/// Reads the Premium purchase straight from the store, like the billing
/// controller's restore: Play Billing's purchase token on Android, the
/// StoreKit 2 original transaction id on iOS.
class StoreFamilyPurchaseSource implements FamilyPurchaseSource {
  const StoreFamilyPurchaseSource();

  @override
  Future<FamilyStorePurchase?> premiumPurchase() async {
    if (kIsWeb) return null;
    if (Platform.isAndroid) {
      final addition = InAppPurchase.instance
          .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final response = await addition.queryPastPurchases();
      if (response.error != null) {
        throw FamilyException(
          FamilyErrorCodes.noPurchaseFound,
          response.error!.message,
        );
      }
      for (final purchase in response.pastPurchases) {
        if (PremiumProductIds.all.contains(purchase.productID) &&
            (purchase.status == PurchaseStatus.purchased ||
                purchase.status == PurchaseStatus.restored)) {
          return FamilyStorePurchase.google(
            purchase.verificationData.serverVerificationData,
          );
        }
      }
      return null;
    }
    if (Platform.isIOS || Platform.isMacOS) {
      final transactions = await SK2Transaction.transactions();
      SK2Transaction? latest;
      for (final transaction in transactions) {
        if (!PremiumProductIds.all.contains(transaction.productId)) continue;
        if (latest == null ||
            (int.tryParse(transaction.purchaseDate) ?? 0) >
                (int.tryParse(latest.purchaseDate) ?? 0)) {
          latest = transaction;
        }
      }
      return latest == null
          ? null
          : FamilyStorePurchase.apple(latest.originalId);
    }
    return null;
  }
}
