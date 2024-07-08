import 'package:flutter/material.dart';
import 'package:game_tracker/controllers/game_controller.dart';
import 'package:game_tracker/models/game.dart';

class CreateGame extends StatefulWidget {
  final VoidCallback signOut;
  final int userId;

  CreateGame({required this.signOut, required this.userId});

  @override
  State<CreateGame> createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> {
  final GameController gameController = GameController();
  final _formKey = GlobalKey<FormState>();
  String _name = "", _description = "", _releaseDate = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Game',
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
                    'New Game',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'Lexend',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  _inputField("name"),
                  const SizedBox(height: 10),
                  _inputField("description"),
                  const SizedBox(height: 10),
                  _inputField("release date"),
                  const SizedBox(height: 50),
                  _createBtn(),
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
        } else if (hintText == "description") {
          _description = value!;
        } else {
          _releaseDate = value!;
        }
      },
    );
  }

  Widget _createBtn() {
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
          "Create Game",
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
        // Criar um objeto Game com os dados fornecidos
        Game newGame = Game(
          name: _name,
          description: _description,
          releaseDate: _releaseDate,
          userId: widget.userId,
        );

        // Chamar o método no GameController para salvar o jogo
        await gameController.saveGame(newGame);

        // Mostrar um snackbar ou mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Game created successfully!')),
        );

        // Voltar para a tela anterior (Dashboard)
        Navigator.pop(context);

      } catch (e) {
        // Mostrar uma mensagem de erro caso ocorra algum problema
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create game: $e')),
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
