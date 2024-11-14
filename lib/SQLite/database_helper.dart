import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../JSON/users.dart';

class DatabaseHelper {
  final String databaseName = "auth.db";

  //Tables

  // Ne mettez pas de virgule à la fin d'une colonne dans SQLite

  String user = '''
   CREATE TABLE users (
   usrId INTEGER PRIMARY KEY AUTOINCREMENT,
   fullName TEXT,
   email TEXT,
   usrName TEXT UNIQUE,
   usrPassword TEXT
   )
   ''';

  // Notre connexion est prête
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(user);
    });
  }

  // Méthodes de fonction

  // Authentification
  Future<bool> authenticate(Users usr) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
        "SELECT * FROM users WHERE usrName = '${usr.usrName}' AND usrPassword = '${usr.password}' ");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // Inscription
  Future<int> createUser(Users usr) async {
    final Database db = await initDB();
    return db.insert("users", usr.toMap());
  }

  // Obtenir les détails de l'utilisateur actuel
  Future<Users?> getUser(String usrName) async {
    final Database db = await initDB();
    var res = await db.query("users", where: "usrName = ?", whereArgs: [usrName]);
    return res.isNotEmpty ? Users.fromMap(res.first) : null;
  }
}
