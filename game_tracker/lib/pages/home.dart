import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:game_tracker/pages/dashboard.dart';
import 'package:game_tracker/pages/signup.dart';
import 'package:game_tracker/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:game_tracker/controller/login_controller.dart';

enum LoginStatus { notSignin, signIn }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LoginStatus _loginStatus = LoginStatus.notSignin;
  final _formKey = GlobalKey<FormState>();
  String _email = "", _password = "";
  late LoginController controller;
  var value;

  _HomePageState() {
    this.controller = LoginController();
  }

  savePref(int value, String email, String pass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.setInt("value", value);
      preferences.setString("email", email);
      preferences.setString("pass", pass);
    });
  }

  void _submit() async {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();

      try {
        User user = await controller.getLogin(_email, _password);
        if (user.id != -1) {
          savePref(1, user.email, user.password);
          setState(() {
            _loginStatus = LoginStatus.signIn;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not registered!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.setInt("value", 0);
      _loginStatus = LoginStatus.notSignin;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignin;
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentWidget;

    switch (_loginStatus) {
      case LoginStatus.notSignin:
        currentWidget = Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(),
        );
        break;
      case LoginStatus.signIn:
        currentWidget = Dashboard();
        break;
    }

    return currentWidget;
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _inputField("email"),
                const SizedBox(height: 10),
                _inputField("password"),
                const SizedBox(height: 20),
                _loginBtn(),
                _signupBtn(),
                _guestBtn()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String hintText) {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Lexend'),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: hintText == "password",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hintText';
        }
        return null;
      },
      onSaved: (value) {
        if (hintText == "email") {
          _email = value!;
        } else {
          _password = value!;
        }
      },
    );
  }

  Widget _loginBtn() {
    return ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 109, 49, 237),
        ),
        child: const SizedBox(
          width: double.infinity,
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontFamily: 'Lexend', color: Colors.white),
          ),
        ));
  }

  Widget _signupBtn() {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Signup()),
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
                fontSize: 20, fontFamily: 'Lexend', color: Colors.white),
          ),
        ));
  }

  Widget _guestBtn() {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 109, 49, 237),
        ),
        child: const SizedBox(
          width: double.infinity,
          child: Text(
            "Guest",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontFamily: 'Lexend', color: Colors.white),
          ),
        ));
  }
}
