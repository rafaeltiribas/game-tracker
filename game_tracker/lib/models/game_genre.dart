class GameGenre {
  final int? id;
  final int gameId;
  final int genreId;

  GameGenre({this.id, required this.gameId, required this.genreId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "game_id": gameId,
      "genre_id": genreId,
    };
  }

  factory GameGenre.fromMap(Map<String, dynamic> map) {
    return GameGenre(
      id: map["id"],
      gameId: map["game_id"],
      genreId: map["genre_id"],
    );
  }
}
