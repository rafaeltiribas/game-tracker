import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:game_tracker/controllers/game_controller.dart';

class RemoveGame extends StatefulWidget {
  final VoidCallback signOut;

  RemoveGame(this.signOut);

  @override
  State<RemoveGame> createState() => _RemoveGameState();
}

class _RemoveGameState extends State<RemoveGame> {
  final GameController gameController = GameController();
  final _formKey = GlobalKey<FormState>();
  int _gameID = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Remove Game',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontFamily: 'Lexend',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              signOut();
            },
            icon: Icon(Icons.lock_open),
          )
        ],
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
                  const Text(
                    'Game' ,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'Lexend',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  _inputField("id"),
                  const SizedBox(height: 25),
                  _removeBtn(),
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
        if (hintText == "id") {
          _gameID = int.parse(value!); // Convert value to integer
        }
      },
      keyboardType: hintText == "id" ? TextInputType.number : TextInputType.text,
      // Ensure proper keyboard type based on the input type
    );
  }

  Widget _removeBtn() {
    return ElevatedButton(
      onPressed: () {
        _submit();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 109, 49, 237),
      ),
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          "Remove Game",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontFamily: 'Lexend', color: Colors.white),
        ),
      ),
    );
  }

  void _submit() async {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();

      try {

        // Chamar o método no GameController para salvar o jogo
        await gameController.deleteGameById(_gameID);

        // Mostrar um snackbar ou mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Game removed successfully!')),
        );

        // Voltar para a tela anterior (Dashboard)
        Navigator.pop(context);

      } catch (e) {
        // Mostrar uma mensagem de erro caso ocorra algum problema
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove game: $e')),
        );
      }
    }
  }

  void signOut() {
    setState(() {
      widget.signOut();
    });
  }
}
