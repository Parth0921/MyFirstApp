import 'package:flutter/material.dart';
import 'package:my_start_app/constants/routes.dart';
import 'package:my_start_app/services/auth/auth_service.dart';
import 'package:my_start_app/views/login_view.dart';
import 'package:my_start_app/views/notes_view.dart';
import 'package:my_start_app/views/register_view.dart';
import 'package:my_start_app/views/verify_email.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Backend Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomePage(),
      routes: {
        loginRoute : (context) => const LoginView(),
        registerRoute : (context) => const RegisterView(),
        notesRoute : (context) => const NotesView(),
        verifyEmailRoute :(context) => const VerifyEmailView(),
      },
    ),);
}

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot){
             switch (snapshot.connectionState){
               case ConnectionState.done:
               final user = AuthService.firebase().currentUser;
               if (user!= null){
                 if(user.isEmailVerified){
                 return const NotesView(); 
                 } else {
                   return const VerifyEmailView();
                 }
               } else {
                 return const LoginView();
               }
              // return NotesView();           
          default : 
          return const CircularProgressIndicator();
        }
            
       },
      );
  }
}
