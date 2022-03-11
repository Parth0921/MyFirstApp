import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({ Key? key }) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
   _email.dispose();
   _password.dispose();
    super.dispose();
  }


   @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: const Text('Register'),),
       body:   Column(
              children: [
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email here',
                  ),
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await Firebase.initializeApp(
                      options: DefaultFirebaseOptions.currentPlatform,
                    );
                    Navigator.of(context).pushNamedAndRemoveUntil( 
                     '/login/',
                    (route) => false);
                  final email = _email.text;
                  final password = _password.text;
                 
                  try{
                      final userCredential = 
                      await FirebaseAuth.instance.createUserWithEmailAndPassword(
                     email: email, 
                     password: password);
                     devtools.log(userCredential.toString()); 
                  }
                  on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password')
                    {
                      devtools.log('weak password');
                    }
                    else if (e.code == 'email-already-in-use'){
                      devtools.log('user already exists');
                    }
                    else if (e.code == 'invalid-email'){
                      devtools.log('Invalid Email');
                    }
                  }
                  // ignore: non_constant_identifier_names
                  
                  }, 
                child: const Text('Register'),
                 ),
                 TextButton(
                   onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil( 
                     '/login/',
                    (route) => false);
                   }, 
                   child: const Text('Already a user? click herer to login'))
              ],
            ),
     );
  }
}
