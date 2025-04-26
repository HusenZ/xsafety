import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/chat_model.dart';

class ChatDbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'emergency_chat.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE chats (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            role TEXT,
            text TEXT,
            emergencyType TEXT,
            createdAt TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  static Future<void> insertChat(ChatModel chat, String emergencyType) async {
    final db = await database;
    await db.insert('chats', chat.toDbMap(emergencyType));
  }

  static Future<List<ChatModel>> getChats(String emergencyType) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'chats',
      where: 'emergencyType = ?',
      whereArgs: [emergencyType],
    );
    return maps.map((map) => ChatModel.fromDbMap(map)).toList();
  }
}
