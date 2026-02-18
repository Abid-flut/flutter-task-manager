
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/state/auth_provider.dart';

class LoginScreen extends StatefulWidget{

  const LoginScreen({
    super.key
  });

  State<LoginScreen> createState()=> _LoginScreen();

}

class _LoginScreen extends State<LoginScreen>{

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    void Login(String username, String password){
      context.read<AuthProvider>().login(username, password);
    }

    return Scaffold(
      appBar: AppBar(title: Text("Login Screen")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: userNameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            SizedBox(height:10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            if(auth.error != null)
              Text(auth.error!),
            ElevatedButton(
                onPressed:(){
                  if(!auth.isLoading)
                    Login(userNameController.text, passwordController.text);
                },
                child: auth.isLoading?
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),):Text("Login"),
            )
          ],
        ),
      )
    );
  }


}