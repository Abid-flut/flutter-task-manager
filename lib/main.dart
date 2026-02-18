import 'package:flutter/material.dart';
import 'package:task_app/state/auth_provider.dart';
import 'package:task_app/ui/screens/loading_screen.dart';
import 'package:task_app/ui/screens/login_screen.dart';
import 'package:task_app/ui/screens/task_list_screen.dart';
import 'package:task_app/ui/screens/add_task_screen.dart';
import 'state/task_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
        providers:[
          ChangeNotifierProvider(create: (_)=> TaskProvider() ),
          ChangeNotifierProvider(create: (_)=> AuthProvider()),
        ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final auth = context.watch<AuthProvider>();

    Widget homeScreen;

    if(auth.isChecking){
      homeScreen = LoadingScreen();
    }
    else if(auth.isAuthenticated){
      homeScreen = TaskListScreen();
    }
    else{
       homeScreen= LoginScreen();
    }


    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: homeScreen,
    );
  }
}

