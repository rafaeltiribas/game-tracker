import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game_tracker/controller/login_controller.dart';
import 'package:game_tracker/models/user.dart';
import 'package:game_tracker/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SignupStatus { notSignup, signUp }

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  SignupStatus _signupStatus = SignupStatus.notSignup;
  final _formKey = GlobalKey<FormState>();
  String _name = "", _email = "", _password = "";
  late LoginController controller;
  var value;

  _SignupPageState() {
    this.controller = LoginController();
  }

  savePref(int value, String name, String email, String pass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.setInt("signup", value);
      preferences.setString("name", name);
      preferences.setString("email", email);
      preferences.setString("pass", pass);
    });
  }

  void _submit() async {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();
      try {
        User newUser = User(name: _name, email: _email, password: _password);
        int res = await controller.saveUser(newUser);

        if (res != -1) {
          savePref(1, newUser.name, newUser.email, newUser.password);
          setState(() {
            _signupStatus = SignupStatus.signUp;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User already registered!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      value = preferences.getInt("signup");

      _signupStatus = value == 1 ? SignupStatus.signUp : SignupStatus.notSignup;
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentWidget;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Signup',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontFamily: 'Lexend',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _inputField("name"),
                  const SizedBox(height: 10),
                  _inputField("email"),
                  const SizedBox(height: 10),
                  _inputField("password"),
                  const SizedBox(height: 20),
                  _signupBtn(),
                ],
              ),
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
        if (hintText == "name") {
          _name = value!;
        } else if (hintText == "email") {
          _email = value!;
        } else {
          _password = value!;
        }
      },
    );
  }

  Widget _signupBtn() {
    return ElevatedButton(
      onPressed: _submit,
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
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
