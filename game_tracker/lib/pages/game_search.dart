import 'package:flutter/material.dart';
import 'package:game_tracker/controllers/game_controller.dart';
import 'package:game_tracker/models/game.dart';
import 'package:game_tracker/pages/review_page.dart';

class GameSearch extends StatefulWidget {
  final Game game;

  GameSearch(this.game);

  @override
  State<GameSearch> createState() => _GameSearchState();
}

class _GameSearchState extends State<GameSearch> {
  final GameController gameController = GameController();
  final _formKey = GlobalKey<FormState>();


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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
