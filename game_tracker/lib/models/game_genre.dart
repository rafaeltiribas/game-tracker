class GameGenre {
  final int? id;
  final int game_id;
  final int genre_id;

  GameGenre({this.id, required this.game_id, required this.genre_id});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "game_id": game_id,
      "genre_id": genre_id,
    };
  }

  factory GameGenre.fromMap(Map<String, dynamic> map) {
    return Genre(
      id: map["id"],
      game_id: map["game_id"],
      genre_id: map["genre_id"],
    );
  }
}
