import 'package:flutter/material.dart';
import 'package:game_tracker/controllers/game_controller.dart';
import 'package:game_tracker/controllers/genre_controller.dart';
import 'package:game_tracker/controllers/review_controller.dart';
import 'package:game_tracker/controllers/game_genre_controller.dart';
import 'package:game_tracker/models/game.dart';
import 'package:game_tracker/models/genre.dart';
import 'package:game_tracker/models/game_genre.dart';
import 'package:game_tracker/pages/create_game.dart';
import 'package:game_tracker/pages/game_detail_guest.dart';
import 'package:game_tracker/pages/recent_reviews.dart';
import 'package:game_tracker/pages/remove_game.dart';
import 'package:game_tracker/pages/game_detail.dart';

class Dashboard extends StatefulWidget {
  final VoidCallback signOut;
  final int userId;

  Dashboard({required this.signOut, required this.userId});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  final GameController gameController = GameController();
  final ReviewController reviewController = ReviewController();
  final GameGenreController gameGenreController = GameGenreController();
  final GenreController genreController = GenreController();
  List<Game> userGames = [];
  List<Genre> genres = []; // Lista de gêneros
  Genre? selectedGenre; // Gênero selecionado

  @override
  void initState() {
    super.initState();
    _loadUserGames();
    _loadGenres(); // Carregar gêneros
  }

  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  Future<void> _loadUserGames() async {
    var games = await gameController.getAllGames();
    setState(() {
      userGames = games;
    });
  }

  Future<void> _loadGenres() async {
    var genresList = await genreController.getAllGenres();
    setState(() {
      genres = genresList;
    });
  }

  Future<void> _filterGamesByGenre(Genre genre) async {
    List<GameGenre> gameGenres = await gameGenreController.getGameGenreByGenre(genre.id!);
    List<Game> filteredGames = [];

    for (GameGenre gameGenre in gameGenres) {
      Game? game = await gameController.getGameById(gameGenre.gameId);
      if (game != null && game.userId == widget.userId) {
        filteredGames.add(game);
      }
    }

    setState(() {
      userGames = filteredGames;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  'Recent Games',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontFamily: 'Lexend',
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _showSearchDialog,
                      color: Color.fromARGB(255, 109, 49, 237),
                    ),
                  ],
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
                            return Text('Loading...');
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            double averageScore = snapshot.data ?? 0.0;
                            return Text('Score Average: ${averageScore.toStringAsFixed(2)}');
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

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
        builder: (context) => GameDetailGuest(signOut: signOut, game: game, userId: widget.userId),
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
            style: TextStyle(fontSize: 20, fontFamily: 'Lexend', color: Colors.white),
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
            style: TextStyle(fontSize: 20, fontFamily: 'Lexend', color: Colors.white),
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
            style: TextStyle(fontSize: 20, fontFamily: 'Lexend', color: Colors.white),
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
            keyboardType: TextInputType.text,
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
