import 'package:game_tracker/services/database_service.dart';
import '../models/review.dart';

class ReviewController {
  DatabaseHelper con = DatabaseHelper();

  Future<int> saveReview(Review review) async {
    var db = await con.db;
    int res = await db.insert('review', review.toMap());
    return res;
  }

  Future<int> deleteReview(Review review) async {
    var db = await con.db;
    int res = await db.delete("review", where: "id = ?", whereArgs: [review.id]);
    return res;
  }

  Future<Review?> getReviewById(int id) async {
    var db = await con.db;
    var res = await db.query("review", where: "id = ?", whereArgs: [id]);

    if (res.isNotEmpty) {
      return Review.fromMap(res.first);
    }
    return null;
  }

  Future<List<Review>> getAllReviews() async {
    var db = await con.db;
    var res = await db.query("review");

    List<Review> list = res.isNotEmpty ? res.map((c) => Review.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Review>> getRecentReviews() async {
    var db = await con.db;
    String sevenDaysAgo = DateTime.now().subtract(Duration(days: 7)).toIso8601String();
    var res = await db.query(
      "review",
      where: "date >= ?",
      whereArgs: [sevenDaysAgo],
    );

    List<Review> list = res.isNotEmpty ? res.map((c) => Review.fromMap(c)).toList() : [];
    return list;
  }

  Future<double> getGameScoreAvg(int gameId) async {
    var db = await con.db;
    var result = await db.rawQuery(
      'SELECT AVG(score) as avg_score FROM review WHERE game_id = ?',
      [gameId]
    );

    if (result.isNotEmpty && result.first['avg_score'] != null) {
      return result.first['avg_score'] as double;
    } else {
      return 0.0;
    }
  }
}
