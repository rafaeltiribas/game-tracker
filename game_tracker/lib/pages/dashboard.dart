import 'package:flutter/material.dart';
import 'package:game_tracker/controllers/game_controller.dart';
import 'package:game_tracker/models/game.dart';
import 'package:game_tracker/pages/create_game.dart';
import 'package:game_tracker/pages/remove_game.dart';
import 'package:game_tracker/pages/game_detail.dart';

class Dashboard extends StatefulWidget{
  final VoidCallback signOut;
  final int userId;

  Dashboard({required this.signOut, required this.userId});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard>{
  final GameController gameController = GameController();
  List<Game> userGames = [];

  @override
  void initState(){
    super.initState();
    _loadUserGames();
  }

  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  Future<void> _loadUserGames() async {
    var games = await gameController.getGamesByUserId(widget.userId);
    setState(() {
      userGames = games;
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
        'Dashboard',
        style: TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontFamily: 'Lexend',
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: _refreshGames,
          icon: Icon(Icons.refresh),
        ),
        IconButton(
          onPressed: () {
            signOut();
          },
          icon: Icon(Icons.lock_open),
        )
      ],
      centerTitle: true,
    );
  }

  void _refreshGames() {
    _loadUserGames();
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(60.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                'Games',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontFamily: 'Lexend',
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: userGames.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _navigateToGameDetails(userGames[index]);
                    },
                    child: ListTile(
                         title: Text(
                        userGames[index].name,
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontFamily: 'Lexend',
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Rating: ' +
                          userGames[index].id.toString()
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            _createBtn(),
            const SizedBox(height: 20),
            _removeBtn(),
          ],),
      ),
    );
  }

  void _navigateToGameDetails(Game game) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameDetail(signOut: signOut, game: game, userId: widget.userId),
      ),
    );
  }

  Widget _createBtn() {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateGame(signOut: signOut, userId: widget.userId)),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 109, 49, 237),
        ),
        child: const SizedBox(
          width: double.infinity,
          child: Text(
            "Create Game",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontFamily: 'Lexend', color: Colors.white),
          ),
        ));
  }

  Widget _removeBtn() {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RemoveGame(signOut)),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 109, 49, 237),
        ),
        child: const SizedBox(
          width: double.infinity,
          child: Text(
            "Remove Game",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontFamily: 'Lexend', color: Colors.white),
          ),
        ));
  }
}