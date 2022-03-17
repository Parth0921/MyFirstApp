import 'package:my_start_app/services/auth/auth_exceptions.dart';
import 'package:my_start_app/services/auth/auth_provider.dart';
import 'package:my_start_app/services/auth/auth_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Mock Authentication', () {
      final provider = MockAuthProvider();
      test('Should Not Initialize to begin with', (){
        expect(provider.isInitiliazed, false);
      });
      test('Cannot log out if not initialized', (){
        expect(
        provider.logOut(), 
        throwsA(const TypeMatcher<NotInitializedException>()),
        );
      });
      test('Should be able to be Initialized', () async{
          await provider.initialize();
          expect(provider.isInitiliazed, true);
      });

      test('User should be null after initialization', (){
        expect(provider.currentUser, null);
      });

      test('Should be able to initialize in less than 2 seconds', () async{
        await provider.initialize();
        expect (provider.isInitiliazed, true);
        }, timeout: const Timeout(Duration(seconds: 2))
      );
      test('Create user should delegate to login', () async {
       final badEmailUser = provider.createUser(email: 'foo@bar.com', password: 'anypassword');
       expect (badEmailUser,
        throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPassword = provider.createUser(
        email: 'anyemail',
        password: 'foobar'
        );
      expect(badPassword, 
      throwsA(const TypeMatcher<WrongPasswordAuthException>())
      );

      final user = await provider.createUser
      (email: 'foo',
      password: 'bar',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test('Login user should be able to verify', (){
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true); // ! forces to return for optional values
    });
    test('Should be able to logout and login', () async{
        await provider.logOut();
        await provider.logIn(
          email: 'email',
          password: 'pass'
          );
          final user = provider.currentUser;
          expect(user, isNotNull);
    });
  });
}
class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider{
 
 AuthUser? _user;

 var _isInitiliazed = false;
 
 bool get isInitiliazed => _isInitiliazed;

  @override
  Future<AuthUser> createUser({
    required String email, 
    required String password,
    }) async {
    if (!isInitiliazed) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password
      );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async{
     await Future.delayed(const Duration(seconds: 1));
     _isInitiliazed = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
    }) {
    if (!isInitiliazed) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false, email: 'abc@xyz.com',);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitiliazed) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;  
  }

  @override
  Future<void> sendEmailVerification() async {
   if (!isInitiliazed) throw NotInitializedException();
   final user = _user;
   if (user == null) throw UserNotFoundAuthException();
   const newUser = AuthUser(isEmailVerified: true, email: 'abc@xyz.com',);
   _user = newUser;
  }

}