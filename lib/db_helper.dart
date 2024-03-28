import 'package:flutter/widgets.dart';
import 'package:my_assistant/request_model.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'trips';

  static Future<void> initDatabase() async {
    if (_db != null) {
      debugPrint('db is not null');
      return;
    } else {
      try {
        _db = await openDatabase('my_trips.db', version: _version,
            onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE trips (id INTEGER PRIMARY KEY AUTOINCREMENT, Date TEXT, Vehicle_type TEXT, Product_Line TEXT, Vender TEXT, start_point TEXT, end_point TEXT, Cost TEXT, Requester TEXT, Notes TEXT)');
        });
      } catch (e) {
        print(e);
      }
    }
  }

  static Future<int> insert(RequestModel requestModel) async {
    return await _db!.insert(_tableName, requestModel.toJson());
  }

  static Future<List<RequestModel>> getTasksFromDB() async {
    List<RequestModel> requests = [];
    List<Map> data = await _db!.rawQuery('SELECT * FROM trips');
    for (var element in data) {
      requests.add(RequestModel.fromDB(element));
    }
    return requests;
  }

  static Future<int> updateItem({required RequestModel requestModel, required int id}) async {
    requestModel.id = id;
    Map<String, dynamic> row = requestModel.toJson();
    return await _db!.update(
      _tableName,
      row,
      where: 'id = ?',
      whereArgs: [id.toString()],
    );
  }

  static Future<int> deleteItem({required int id}) async {
    return await _db!.rawDelete('DELETE FROM Task WHERE id = ?', [id]);
  }
}
