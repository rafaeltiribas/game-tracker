import 'package:path/path.dart';
import 'package:sqflite_common/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import "../models/user.dart";

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  static Database? _db;
  
  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  Future<Database> get db async {
    return _db ??= await initDb();
  }

  Future<Database> initDb() async {
    sqfliteFfiInit();

    var databaseFactory = databaseFactoryFfi;
    final io.Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String path = p.join(appDocumentsDir.path, "databases", "gametracker.db");
    print("Database Path: $path");

    Database db = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE user(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name VARCHAR NOT NULL,
              email VARCHAR NOT NULL,
              password VARCHAR NOT NULL
            );
          ''');

          await db.execute('''
            INSERT INTO user(name, email, password) VALUES('Teste 1', 'teste1@teste', '123456');
            INSERT INTO user(name, email, password) VALUES('Teste 2', 'teste2@teste', '123456');
            INSERT INTO user(name, email, password) VALUES('Teste 3', 'teste3@teste', '123456');
            INSERT INTO user(name, email, password) VALUES('Teste 4', 'teste4@teste', '123456');
            INSERT INTO user(name, email, password) VALUES('Teste 5', 'teste5@teste', '123456');
          ''');

          await db.execute('''
            CREATE TABLE genre(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name VARCHAR NOT NULL
            );
          ''');

          await db.execute('''
            INSERT INTO genre(name) VALUES('Aventura');
            INSERT INTO genre(name) VALUES('Ação');
            INSERT INTO genre(name) VALUES('RPG');
            INSERT INTO genre(name) VALUES('Plataforma');
            INSERT INTO genre(name) VALUES('Metroidvania');
            INSERT INTO genre(name) VALUES('Rogue Lite');
            INSERT INTO genre(name) VALUES('Survival Horror');
            INSERT INTO genre(name) VALUES('Mundo Aberto');
          ''');

          await db.execute('''
            CREATE TABLE game(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id INTEGER NOT NULL,
              name VARCHAR NOT NULL UNIQUE,
              description TEXT NOT NULL,
              release_date VARCHAR NOT NULL,
              FOREIGN KEY(user_id) REFERENCES user(id)
            );
          ''');

          await db.execute('''
            INSERT INTO game(user_id, name, description, release_date) VALUES(1, 'God of War', 'O jogo começa após a morte da segunda esposa de Kratos e mãe de Atreus, Faye. Seu último desejo era que suas cinzas fossem espalhadas no pico mais alto dos nove reinos nórdicos. Antes de iniciar sua jornada, Kratos é confrontado por um homem misterioso com poderes divinos.', '2018-04-18');
            INSERT INTO game(user_id, name, description, release_date) VALUES(1, 'Resident Evil 4', 'Resident Evil 4 é um jogo de terror e sobrevivência no qual os jogadores terão que enfrentar situações extremas de medo. Apesar dos vários elementos de terror, o jogo é equilibrado com muita ação e uma experiência de jogo bastante variada.', '2023-03-24');
            INSERT INTO game(user_id, name, description, release_date) VALUES(2, 'Persona 5', 'Transferido para a Academia Shujin, em Tóquio, Ren Amamiya está prestes a entrar no segundo ano do colegial. Após um certo incidente, sua Persona desperta, e junto com seus amigos eles formam os Ladrões-Fantasma de Corações, para roubar a fonte dos desejos deturpados dos adultos e assim reformar seus corações.', '2017-04-17');
            INSERT INTO game(user_id, name, description, release_date) VALUES(3, 'Horizon Zero Dawn', 'Horizon Zero Dawn é um RPG eletrônico de ação em que os jogadores controlam a protagonista Aloy, uma caçadora e arqueira, em um cenário futurista, um mundo aberto pós-apocalíptico dominado por criaturas mecanizadas como robôs dinossauros.', '2017-02-28');
          ''');

          await db.execute('''
            CREATE TABLE game_genre(
              game_id INTEGER NOT NULL,
              genre_id INTEGER NOT NULL,
              FOREIGN KEY(game_id) REFERENCES game(id),
              FOREIGN KEY(genre_id) REFERENCES genre(id)
            );
          ''');

          await db.execute('''
            INSERT INTO game_genre(game_id, genre_id) VALUES(1, 1);
            INSERT INTO game_genre(game_id, genre_id) VALUES(2, 7);
            INSERT INTO game_genre(game_id, genre_id) VALUES(3, 3);
            INSERT INTO game_genre(game_id, genre_id) VALUES(4, 2);
            INSERT INTO game_genre(game_id, genre_id) VALUES(4, 3);
            INSERT INTO game_genre(game_id, genre_id) VALUES(4, 8);
          ''');

          await db.execute('''
            CREATE TABLE review(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id INTEGER NOT NULL,
              game_id INTEGER NOT NULL,
              score REAL NOT NULL,
              description TEXT,
              date VARCHAR NOT NULL,
              FOREIGN KEY(user_id) REFERENCES user(id),
              FOREIGN KEY(game_id) REFERENCES game(id)
            );
          ''');

          await db.execute('''
            INSERT INTO review(user_id, game_id, score, description, date) VALUES(1, 1, 9.5, 'Teste', '2024-06-20');
            INSERT INTO review(user_id, game_id, score, description, date) VALUES(2, 1, 9.0, 'Teste', '2024-06-20');
            INSERT INTO review(user_id, game_id, score, description, date) VALUES(3, 1, 8.5, 'Teste', '2024-06-20');
            INSERT INTO review(user_id, game_id, score, description, date) VALUES(4, 1, 9.6, 'Teste', '2024-06-20');
          ''');
        }
      )
    );

    return db;
  }


}