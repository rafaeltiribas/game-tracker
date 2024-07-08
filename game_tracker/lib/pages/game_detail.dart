import 'package:flutter/material.dart';
import 'package:game_tracker/controllers/game_controller.dart';
import 'package:game_tracker/models/game.dart';
import 'package:game_tracker/pages/review_page.dart';

class GameDetail extends StatefulWidget {
  final VoidCallback signOut;
  final int userId;
  final Game game;

  GameDetail({required this.signOut, required this.userId, required this.game});

  @override
  State<GameDetail> createState() => _GameDetailState();
}

class _GameDetailState extends State<GameDetail> {
  final GameController gameController = GameController();
  final _formKey = GlobalKey<FormState>();

  void signOut() {
    setState(() {
      widget.signOut();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Game Detail',
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
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: ${widget.game.name}',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Lexend',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Description: ${widget.game.description}',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Lexend',
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Release Date: ${widget.game.releaseDate}',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Lexend',
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Id: ${widget.game.id}',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Lexend',
                    fontSize: 16,
                  ),
                ),
                // Add more fields if needed
                SizedBox(height: 25),
                _createReviewBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createReviewBtn() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReviewPage(signOut: signOut, game: widget.game, userId: widget.userId)),
          );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 109, 49, 237),
      ),
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          "Review",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontFamily: 'Lexend', color: Colors.white),
        ),
      ),
    );
  }
}
