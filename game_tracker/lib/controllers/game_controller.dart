import 'package:game_tracker/services/database_service.dart';
import '../models/game.dart';

class GameController {
  DatabaseHelper con = DatabaseHelper();

  Future<int> saveGame(Game game) async {
    var db = await con.db;
    int res = await db.insert('game', game.toMap());
    return res;
  }

  Future<int> deleteGame(Game game) async {
    var db = await con.db;
    int res = await db.delete("game", where: "id = ?", whereArgs: [game.id]);
    return res;
  }

  Future<int> deleteGameById(int game_id) async {
    var db = await con.db;
    int res = await db.delete("game", where: "id = ?", whereArgs: [game_id]);
    return res;
  }

  Future<Game?> getGameById(int id) async {
    var db = await con.db;
    var res = await db.query("game", where: "id = ?", whereArgs: [id]);

    if (res.isNotEmpty) {
      return Game.fromMap(res.first);
    }
    return null;
  }

  Future<List<Game>> getAllGames() async {
    var db = await con.db;
    var res = await db.query("game");

    List<Game> list = res.isNotEmpty ? res.map((c) => Game.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Game>> getGamesByUserId(int userId) async {
    var db = await con.db;
    var res = await db.query("game", where: "user_id = ?", whereArgs: [userId]);

    List<Game> list = res.isNotEmpty ? res.map((c) => Game.fromMap(c)).toList() : [];
    return list;
  }
}
