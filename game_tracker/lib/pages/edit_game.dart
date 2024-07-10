import 'package:flutter/material.dart';
import 'package:game_tracker/controllers/game_controller.dart';
import 'package:game_tracker/controllers/review_controller.dart';
import 'package:game_tracker/models/game.dart';

class EditGamePage extends StatefulWidget {
  final VoidCallback signOut;
  final Game game;
  final int userId;

  EditGamePage({required this.signOut, required this.game, required this.userId});

  @override
  State<EditGamePage> createState() => _EditGamePageState();
}

class _EditGamePageState extends State<EditGamePage> {
  final ReviewController reviewController = ReviewController();
  final GameController gameController = GameController();
  final _formKey = GlobalKey<FormState>();
  String _description = "";
  String _name = "";
  String _releasedate = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Game',
          style: const TextStyle(
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
                  Text(
                    widget.game.name,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'Lexend',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  _inputField("name", isNumeric: true),
                  const SizedBox(height: 10),
                  _inputField("description"),
                  const SizedBox(height: 10),
                  _inputField("release date"),
                  const SizedBox(height: 50),
                  _submitBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String hintText, {bool isNumeric = false}) {
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
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter game $hintText';
        }
        return null;
      },
      onSaved: (value) {
        if (hintText.contains("name")) {
          _name = value!;
        } else if (hintText.contains("description")) {
          _description = value!;
        } else {
          _releasedate = value!;
        }
      },
    );
  }

  Widget _submitBtn() {
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
          "Save Edit",
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

      if (widget.game.id != null) {
        try {

          gameController.deleteGame(widget.game);

          Game newGame = Game(
            userId: widget.userId,
            name: _name,
            description: _description,
            releaseDate: _releasedate,
          );

          await gameController.saveGame(newGame);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Edit saved successfully!')),
          );

          Navigator.pop(context);

        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to edit game: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid game ID')),
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
