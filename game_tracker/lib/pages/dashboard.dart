import 'package:flutter/material.dart';
import 'package:game_tracker/controllers/game_controller.dart';
import 'package:game_tracker/controllers/review_controller.dart';
import 'package:game_tracker/models/game.dart';
import 'package:game_tracker/pages/create_game.dart';
import 'package:game_tracker/pages/recent_reviews.dart';
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
  final ReviewController reviewController = ReviewController();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Games',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontFamily: 'Lexend',
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _showSearchDialog,
                  color: Color.fromARGB(255, 109, 49, 237),
                ),
              ],
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
                      subtitle: FutureBuilder<double>(
                        future: reviewController.getGameScoreAvg(userGames[index].id ?? 0),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text('Loading...'); // Mostra 'Carregando...' enquanto espera
                          } else if (snapshot.hasError) {
                            return Text('Erro: ${snapshot.error}'); // Mostra uma mensagem de erro, caso ocorra algum erro
                          } else {
                            double averageScore = snapshot.data ?? 0.0; // Obtém a média de score ou define como 0.0 se for nulo
                            return Text('Score Average: ${averageScore.toStringAsFixed(2)}'); // Exibe o score com duas casas decimais
                          }
                        },
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
            const SizedBox(height: 20),
            _reviewsBtn(),
          ],
        ),
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

  Widget _reviewsBtn() {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecentReviews(signOut: signOut, userId: widget.userId)),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 109, 49, 237),
        ),
        child: const SizedBox(
          width: double.infinity,
          child: Text(
            "Recent Reviews",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontFamily: 'Lexend', color: Colors.white),
          ),
        ));
  }

  void _showSearchDialog() {
    TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Search Game by name'),
          content: TextField(
            controller: searchController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter game name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String? gameName = searchController.text;
                Game? game = await gameController.getGameByName(gameName);
                if (game != null) {
                  Navigator.pop(context); // Close the dialog
                  _navigateToGameDetails(game);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Game not found!')),
                  );
                }
                            },
              child: Text('Search'),
            ),
          ],
        );
      },
    );
  }
}