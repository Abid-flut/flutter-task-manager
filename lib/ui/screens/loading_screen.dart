
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget{

  const LoadingScreen({
    super.key
  });

  State<LoadingScreen> createState()=> _LoadingScreen();

}

class _LoadingScreen extends State<LoadingScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator()
        ],
      ),
    );
  }
}