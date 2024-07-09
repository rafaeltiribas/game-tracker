import 'package:flutter/material.dart';
import 'package:game_tracker/controllers/game_controller.dart';
import 'package:game_tracker/controllers/review_controller.dart';
import 'package:game_tracker/models/game.dart';
import 'package:game_tracker/models/review.dart';
import 'package:game_tracker/pages/create_game.dart';
import 'package:game_tracker/pages/remove_game.dart';
import 'package:game_tracker/pages/game_detail.dart';

class RecentReviews extends StatefulWidget{
  final VoidCallback signOut;
  final int userId;

  RecentReviews({required this.signOut, required this.userId});

  @override
  State<RecentReviews> createState() => _RecentReviewsState();
}

class _RecentReviewsState extends State<RecentReviews>{
  final GameController gameController = GameController();
  List<Game> allGames = [];

  final ReviewController reviewController = ReviewController();
  List<Review> recentReviews = [];

  @override
  void initState(){
    super.initState();
    _loadRecentReviews();
    _loadAllGames();
  }

  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  Future<void> _loadRecentReviews() async {
    var reviews = await reviewController.getRecentReviews();
    setState(() {
      recentReviews = reviews;
    });
  }

  Future<void> _loadAllGames() async {
    var games = await gameController.getAllGames();
    setState(() {
      allGames = games;
    });
  }

  String _getGameName(int gameId) {
    var game = allGames.firstWhere((game) => game.id == gameId, orElse: () => Game(id: gameId, userId: 0, name: 'Unknown', description: '', releaseDate: ''));
    return game.name;
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
        'Recent Reviews',
        style: TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontFamily: 'Lexend',
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: _refreshReviews,
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

  void _refreshReviews(){
    _loadRecentReviews();
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(60.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                'Reviews',
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
                itemCount: recentReviews.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                    },
                    child: ListTile(
                        title: Text(
                        _getGameName(recentReviews[index].gameId),
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontFamily: 'Lexend',
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Rating: ${recentReviews[index].score}\nDescription ${recentReviews[index].description}'
                      ),
                    ),
                  );
                },
              ),
            ),
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
}