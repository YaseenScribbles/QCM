import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'QCM');
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    return database;
  }

  Future<void> _createDb(Database database, int version) async {
    String userInfoTable = """
      CREATE TABLE user_info (
        id INTERGER PRIMARY KEY,
        email TEXT,
        password TEXT,
        token TEXT,
        name TEXT,
        role TEXT,
        phone TEXT,
        isactive INTEGER,
        userid INTEGER
      );
    """;
    await database.execute(userInfoTable);
  }
}
