import 'package:remit/core/entity/ResponseData.dart';
import 'package:remit/core/entity/UserAccount.dart';

abstract class IAuthRepository {
  /// This stream can be used to listen for changes to the authenticated user
  /// across different data sources.
  ///
  /// Returns a [Stream] of [UserAccount] which can be `null` if the user is not authenticated.
  Stream<UserAccount?> get user;

  /// Logs in the user using Google OAuth.
  ///
  /// Initiates the Google login flow and returns a [ResponseData] containing the
  /// authenticated [UserAccount] if successful.
  ///
  /// Returns a [Future] of [ResponseData] containing the [UserAccount].
  Future<ResponseData<UserAccount?>> loginWithGoogle();

  // Same goes here for third-party oauth login flow
  Future<ResponseData<UserAccount?>> loginWithFacebook();
  Future<ResponseData<UserAccount?>> loginWithGithub();

  Future<ResponseData<UserAccount?>> updateAccount(UserAccount? account);
  Future<ResponseData<UserAccount?>> loginWithEmailAndPassword(
    String email,
    String password,
  );
  Future<ResponseData<UserAccount?>> createAccount(
    UserAccount account,
    String password,
  );
  Future<dynamic> forgotPassword(String email);
  Future<ResponseData> logOut();
}
