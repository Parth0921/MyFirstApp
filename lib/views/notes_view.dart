import 'package:flutter/material.dart';
import 'package:my_start_app/constants/routes.dart';
import 'package:my_start_app/enums/menu_action.dart';
import 'package:my_start_app/services/auth/auth_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({ Key? key }) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction> (
            onSelected :(value)  async{
              switch (value) {
                
                case MenuAction.logout:
                  final shouldLogout = await showOutputDialog(context);
                  if (shouldLogout){
                    await AuthService.firebase().logOut();
                   Navigator.of(context).pushNamedAndRemoveUntil(
                     loginRoute,
                       (_) => false);
                  }
              }
            }, 
            itemBuilder: (context) {
              return const [
                  PopupMenuItem<MenuAction>(
                  value: MenuAction.logout, 
                  child: Text('Log Out') ,
                  ),
              ];
            },
          ) 
        ]
      ),
      body: const Text('Hello User'),
    );
  }
}

Future<bool> showOutputDialog(BuildContext context){
  return showDialog(
    context: context,  
    builder: (context){
       return AlertDialog(
      title: const Text('Sign out'),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop(false);
        }, 
        child: const Text('Cancel'),),
        TextButton(onPressed: () {
          Navigator.of(context).pop(true);
        }, 
        child: const Text('Log out'),),
      ],
       );
    }
   
    ).then((value) => value ?? false);
}