import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class OfflineStorage {
  static final OfflineStorage _instance = OfflineStorage._internal();
  Database? _database;

  factory OfflineStorage() => _instance;

  OfflineStorage._internal();

  Future<void> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'insuretech.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE claims(id INTEGER PRIMARY KEY, description TEXT, status TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> addClaim(Map<String, dynamic> claim) async {
    await _database!.insert('claims', claim);
  }

  Future<List<Map<String, dynamic>>> fetchClaims() async {
    return await _database!.query('claims');
  }
}
