import 'package:flutter/material.dart';
import 'package:project_flutter/Components/button.dart';
import 'package:project_flutter/Components/colors.dart';
import 'package:project_flutter/Components/textfield.dart';
import 'package:project_flutter/JSON/users.dart';

import 'package:project_flutter/Views/signup.dart';
import 'package:project_flutter/Views/home.dart'; // Import home.dart

import '../SQLite/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Our controllers
  final usrName = TextEditingController();
  final password = TextEditingController();

  bool isChecked = false;
  bool isLoginTrue = false;

  final db = DatabaseHelper();

  //Login Method
  login() async {
    Users? usrDetails = await db.getUser(usrName.text);
    var res = await db.authenticate(Users(usrName: usrName.text, password: password.text));
    if (res == true) {
      // If result is correct then navigate to home
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen())); // Navigate to HomeScreen
    } else {
      // Otherwise show the error message
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("LOGIN",style: TextStyle(color: primaryColor,fontSize: 40),),
                Image.asset("assets/background.jpg"),
                InputField(hint: "Username", icon: Icons.account_circle, controller: usrName),
                InputField(hint: "Password", icon: Icons.lock, controller: password,passwordInvisible: true),
                ListTile(
                  horizontalTitleGap: 2,
                  title: const Text("Remember me"),
                  leading: Checkbox(
                    activeColor: primaryColor,
                    value: isChecked,
                    onChanged: (value){
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                  ),
                ),
                Button(label: "LOGIN", press: (){
                  login();
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?",style: TextStyle(color: Colors.grey),),
                    TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignupScreen()));
                      },
                      child: const Text("SIGN UP"),
                    ),
                  ],
                ),
                // Access denied message in case when your username and password is incorrect
                // By default we must hide it
                // When login is not true then display the message
                isLoginTrue? Text("Username or password is incorrect",style: TextStyle(color: Colors.red.shade900),):const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
