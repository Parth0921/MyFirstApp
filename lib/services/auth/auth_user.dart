import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable //internals wouldn't be changed after initialization, all it's subclasses should be immutable as well
class AuthUser {
  final String id;
  final bool isEmailVerified;
  final String email;

  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });
  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );
}
