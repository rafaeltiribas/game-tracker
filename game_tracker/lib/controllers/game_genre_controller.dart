import 'package:game_tracker/services/database_service.dart';
import '../models/game_genre.dart';

class GameGenreController {
  DatabaseHelper con = DatabaseHelper();

  Future<int> saveGameGenre(GameGenre gameGenre) async {
    var db = await con.db;
    int res = await db.insert('game_genre', gameGenre.toMap());
    return res;
  }

  Future<int> deleteGameGenre(GameGenre gameGenre) async {
    var db = await con.db;
    int res = await db.delete("game_genre", where: "id = ?", whereArgs: [gameGenre.id]);
    return res;
  }

  Future<GameGenre?> getGameGenreById(int id) async {
    var db = await con.db;
    var res = await db.query("game_genre", where: "id = ?", whereArgs: [id]);

    if (res.isNotEmpty) {
      return GameGenre.fromMap(res.first);
    }
    return null;
  }

  Future<List<GameGenre>> getGameGenreByGenre(int id) async {
    var db = await con.db;
    var res = await db.query("game_genre", where: "genre_id = ?", whereArgs: [id]);

    List<GameGenre> list = res.isNotEmpty ? res.map((c) => GameGenre.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<GameGenre>> getAllGameGenres() async {
    var db = await con.db;
    var res = await db.query("game_genre");

    List<GameGenre> list = res.isNotEmpty ? res.map((c) => GameGenre.fromMap(c)).toList() : [];
    return list;
  }
}
