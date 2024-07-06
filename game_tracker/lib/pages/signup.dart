import 'package:flutter/material.dart';
import 'package:game_tracker/controller/login_controller.dart';
import 'package:game_tracker/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SignupStatus { notSignup, signUp }

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

 class _SignupPageState extends State<SignupPage>{
  SignupStatus _signupStatus = SignupStatus.notSignup;
  final _formKey = GlobalKey<FormState>();
  String _name = "", _email = "", _password = "";
  late LoginController controller;
  var value;

  _SignupPageState (){
    this.controller = LoginController();
  }

  savePref(int value, String name, String email, String pass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.setInt("value", value);
      preferences.setString("name", name);
      preferences.setString("email", email);
      preferences.setString("pass", pass);
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: const Text(
        'Game Tracker',
        style: TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontFamily: 'Lexend',
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(60.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _inputField("name"),
            const SizedBox(height: 20),
            _inputField("email"),
            const SizedBox(height: 20),
            _inputField("password"),
            const SizedBox(height: 20),
            _loginBtn()
          ],),
      ),
    );
  }

  Widget _inputField(String hintText){
    return TextField(
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Lexend'
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
  Widget _loginBtn(){
    return ElevatedButton(
      onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage()
          )  
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 109, 49, 237),
      ),
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          "Signup",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Lexend',
            color: Colors.white
          ),
        ),
      )
    );
  }
}