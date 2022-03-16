import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';


@immutable //internals wouldn't be changed after initialization, all it's subclasses should be immutable as well
class AuthUser {
  final bool isEmailVerified;

  const AuthUser({ required this.isEmailVerified});
  factory AuthUser.fromFirebase(User user) => 
      AuthUser(isEmailVerified: user.emailVerified);


}