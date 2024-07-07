import 'package:game_tracker/services/database_service.dart';
import '../models/genre.dart';

class GenreController {
  DatabaseHelper con = DatabaseHelper();

  Future<int> saveGenre(Genre genre) async {
    var db = await con.db;
    int res = await db.insert('genre', genre.toMap());
    return res;
  }

  Future<int> deleteGenre(Genre genre) async {
    var db = await con.db;
    int res = await db.delete("genre", where: "id = ?", whereArgs: [genre.id]);
    return res;
  }

  Future<Genre?> getGenreById(int id) async {
    var db = await con.db;
    var res = await db.query("genre", where: "id = ?", whereArgs: [id]);

    if (res.isNotEmpty) {
      return Genre.fromMap(res.first);
    }
    return null;
  }

  Future<List<Genre>> getAllGenres() async {
    var db = await con.db;
    var res = await db.query("genre");

    List<Genre> list = res.isNotEmpty ? res.map((c) => Genre.fromMap(c)).toList() : [];
    return list;
  }
}
