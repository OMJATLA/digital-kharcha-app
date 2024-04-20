// // import 'package:mysql1/mysql1.dart';

// // class Sql {
// //   static MySqlConnection? conn;

// //   static Future<void> connectionOfSql() async {
// //     try {
// //       conn = await MySqlConnection.connect(
// //         ConnectionSettings(
// //           host: 'localhost',
// //           port: 3306,
// //           user: 'root',
// //           password: 'om',
// //           db: 'kharchaDB',
// //         ),
// //       );
// //       final result = await conn!.query("Select * from kharchaDB.users");
// //       // final result = await conn!.query(
// //       //     'INSERT INTO users (name, email) VALUES (?, ?)',
// //       //     ['John Doe', 'john@example.com']);

// //       // if (result.affectedRows! > 0) {
// //       //   print('User added successfully!');
// //       // } else {
// //       //   print('Failed to add user.');
// //       // }
// //     } catch (e) {
// //       print('Error: $e');
// //     } finally {
// //       await conn?.close();
// //     }
// //   }
// // }

// // import 'package:mysql1/mysql1.dart';
// import 'package:mysql_client/mysql_client.dart';

// class Sql {
//   static MySQLConnection? conn;

//   static void connectionOfSql() async {
//     conn = await MySQLConnection.createConnection(
//       host: "127.0.0.1",
//       port: 3306,
//       userName: "root",
//       password: "om",
//       databaseName: "kharchaDB", // optional
//     );
//     await conn!.connect();

//     var result = await conn!.execute("SELECT * FROM kharchaDB.users", {}, true);

//     result.rowsStream.listen((row) {
//       print(row.colByName('name'));
//       // print(row.)
//     });
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Models/transaction_details.dart';

class SqliteService {
  // static RxList<TranscationDetails> transcationDetailsList =
  //     <TranscationDetails>[].obs;
  Database? db;
  Future<void> initializeDB() async {
    debugPrint("Connecting SQL");
    String path = await getDatabasesPath();

    db = await openDatabase(
      join(path, 'kharchaDB.db'),
      onCreate: (database, version) async {
        await database.execute('''
      CREATE TABLE Year(
        year INTEGER PRIMARY KEY, 
        yearly_amount REAL
      );

      CREATE TABLE Month(
        month_id INTEGER PRIMARY KEY AUTOINCREMENT, 
        month_name TEXT NOT NULL, 
        month_number INTEGER NOT NULL, 
        total_monthly_amount REAL, 
        year INTEGER, 
        FOREIGN KEY (year) REFERENCES Year(year)
      );

      CREATE TABLE Day(
        day_id INTEGER PRIMARY KEY AUTOINCREMENT, 
        day_number INTEGER NOT NULL,
        day_name TEXT NOT NULL, 
        date TEXT NOT NULL, 
        total_daily_amount REAL, 
        month_id INTEGER, 
        FOREIGN KEY (month_id) REFERENCES Month(month_id)
      );

      CREATE TABLE Transactions(
        transaction_id INTEGER PRIMARY KEY AUTOINCREMENT, 
        transaction_name TEXT NOT NULL, 
        category TEXT NOT NULL, 
        time TEXT NOT NULL, 
        amount REAL NOT NULL, 
        where_used TEXT NOT NULL, 
        sms TEXT NOT NULL, 
        day_id INTEGER, 
        FOREIGN KEY (day_id) REFERENCES Day(day_id)
      );
    ''');
        print('created');
      },
      version: 1,
    );

    debugPrint("Sql Connection Done......................................");
  }

//inserting...............................
  Future<int> insertTransaction(TranscationDetails note) async {
    if (db == null) {
      String path = await getDatabasesPath();

      // final Database db = await initializeDB();
      db = await openDatabase(
        join(path, 'kharchaDB.db'),
        version: 1,
      );
    }

    // print("osfjofsjfowjwfjfoj" + db.toString());
    await db!.insert('AllTransactions', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return 0;
  }

  Future<List<TranscationDetails>>
      getAllTransactionDetailsListFromDatabase() async {
    // final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db!.query(
      'AllTransactions',
    );
    // debugPrint(queryResult.toString());
    return queryResult.map((e) => TranscationDetails.fromMap(e)).toList();
  }

  Future<void> truncateTable() async {
    // final db = await initializeDB();
    try {
      db!.delete("AllTransactions"); // Truncate the table
    } catch (err) {
      debugPrint("Something went wrong when truncating the table: $err");
    }
  }
}
