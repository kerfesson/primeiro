import 'package:flutter/material.dart';
import 'screens/user_list_screen.dart';


void main() {
  runApp(const crud_usuario());
}

class crud_usuario extends StatelessWidget {
  const crud_usuario({super.key});

  @override
  Widget build(BuildContext context){

return MaterialApp(
title: 'CRUD usuarios SQLte',
debugShowCheckedModeBanner: false,
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
  useMaterial3: 
    true,
  fontFamily: 'roboto',
),
  home: const UserListScreen(),
   );
  }
}
