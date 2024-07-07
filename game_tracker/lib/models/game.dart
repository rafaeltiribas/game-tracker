class Game {
  final int? id;
  final int userId;
  final String name;
  final String description;
  final String releaseDate;

  Game({
    this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.releaseDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "user_id": userId,
      "name": name,
      "description": description,
      "release_date": releaseDate,
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map["id"],
      userId: map["user_id"],
      name: map["name"],
      description: map["description"],
      releaseDate: map["release_date"],
    );
  }
}
