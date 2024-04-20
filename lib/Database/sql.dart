import 'package:digital_kharcha_app/Models/day_table.dart';
import 'package:digital_kharcha_app/Models/month_table.dart';
import 'package:digital_kharcha_app/Models/year_table.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Models/transaction_details.dart';

class SqliteService {
  List<Year>? yearTableData;
  List<Month>? monthTableData;
  List<Day>? dayTableData;

  final int _currentYear = DateTime.now().year;
  final int _currentMonthNumber = DateTime.now().month;
  final int _currentDay = DateTime.now().day;

  static SharedPreferences? prefs;
  Database? db;

  static Future<void> getPrefs() async =>
      prefs = await SharedPreferences.getInstance();

  Future<void> initializeDB() async {
    debugPrint("Connecting SQL");
    String path = await getDatabasesPath();

    db = await openDatabase(
      join(path, 'kharchaDB.db'),
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE Year(
            year_id INTEGER PRIMARY KEY, 
            yearly_amount REAL
          );
        ''');
        print('Year table created');

        await database.execute('''
          CREATE TABLE Month(
            month_id INTEGER PRIMARY KEY AUTOINCREMENT, 
            month_name TEXT NOT NULL, 
            month_number INTEGER NOT NULL, 
            total_monthly_amount REAL,
            date TEXT NOT NULL,
            year_id INTEGER, 
            FOREIGN KEY (year_id) REFERENCES Year(year_id)
          );
        ''');
        print('Month table created');

        await database.execute('''
          CREATE TABLE Day(
            day_id INTEGER PRIMARY KEY AUTOINCREMENT, 
            day_number INTEGER NOT NULL,
            "weekend_number" INTEGER NOT NULL,
            day_name TEXT NOT NULL, 
            date TEXT NOT NULL, 
            total_daily_amount REAL, 
            month_id INTEGER, 
            FOREIGN KEY (month_id) REFERENCES Month(month_id)
          );
        ''');
        print('Day table created');
      },
      version: 1,
    );

    debugPrint("Sql Connection Done......................................");
    await getPrefs();
    if (prefs == null) {
      print("prefs are null..................");
      return;
    }
    await insertYearTableAndGetTheData();
    await insertMonthTableAndGetTheData();
    await insertDayTableAndGetTheData();
  }

  Future<void> insertYearTableAndGetTheData() async {
    // prefs = await SharedPreferences.getInstance();

    String? savedYear = prefs!.getString('year_id');

    // Check if the saved year is null or different from the current year
    if (savedYear == null || savedYear != _currentYear.toString()) {
      print('New year detected: $_currentYear');

      // Update the saved year in SharedPreferences
      prefs!.setString('year_id', _currentYear.toString());
      print("Year updated successfully: $_currentYear");

      // Insert a new record for the new year into the Year table
      await db!.insert(
        'Year',
        {'year_id': _currentYear.toString(), 'yearly_amount': 0.0},
      );
    } else {
      print("Same year ${prefs!.getString('year_id')}");
    }

    // Retrieve and display data from the Year table
    await getYearTableDataFromDB();
  }

  Future<void> getYearTableDataFromDB() async {
    List<Map<String, dynamic>> maps = await db!.query('Year');

    List<Year> data = maps.map((map) {
      return Year(
        yearId: map['year_id'],
        yearlyAmount: map['yearly_amount'],
      );
    }).toList();

    yearTableData = data;
    print("Year table data retrieved:");
    print(yearTableData);
  }

  Future<void> insertMonthTableAndGetTheData() async {
    // prefs = await SharedPreferences.getInstance();

    String formattedDate = getDayMonthYearFormatDate();

    if (prefs!.getInt('currentMonth') == null) {
      print('First time login');

      prefs!.setInt('currentMonth', _currentMonthNumber);
      print('Year and month set successfully');

      await db!.insert(
        'Month',
        {
          'month_name': getMonthName(_currentMonthNumber),
          'date': formattedDate,
          'month_number': _currentMonthNumber,
          'total_monthly_amount': 0.0,
          'year_id': int.parse(prefs!.getString('year_id').toString())
        },
      );
    } else {
      int savedMonth = prefs!.getInt('currentMonth')!;

      if (savedMonth != _currentMonthNumber) {
        print('New month');

        prefs!.setInt('currentMonth', _currentMonthNumber);
        print('Year and month set successfully');

        await db!.insert(
          'Month',
          {
            'month_name': getMonthName(_currentMonthNumber),
            'date': formattedDate,
            'month_number': _currentMonthNumber,
            'total_monthly_amount': 0.0,
            'year_id': int.parse(prefs!.getString('year_id').toString())
          },
        );
      } else {
        print('Same month ${getMonthName(_currentMonthNumber)}');
      }
    } // prefs = await SharedPreferences.getInstance();

    await getMonthTableDataFromDB();
  }

  Future<void> getMonthTableDataFromDB() async {
    List<Map<String, dynamic>> maps = await db!.query('Month');

    List<Month> data = maps.map((map) {
      return Month(
        date: map['date'],
        monthId: map['month_id'],
        monthName: map['month_name'],
        monthNumber: map['month_number'],
        totalMonthlyAmount: map['total_monthly_amount'],
        yearId: map['year_id'],
      );
    }).toList();

    monthTableData = data;
    print('Month table data obtained:');
    print(monthTableData);
  }

  Future<void> insertDayTableAndGetTheData() async {
    String currentDateString = getDayMonthYearFormatDate();
    // prefs = await SharedPreferences.getInstance();

    int currentWeekeendNumber = DateTime.now().weekday;

    if (prefs!.getInt('currentDay') == null) {
      print('First time login');
      prefs!.setInt('currentDay', _currentDay);
      print('Current date set successfully');

      await db!.insert(
        'Day',
        {
          'day_number': _currentDay,
          'weekend_number': currentWeekeendNumber,
          'day_name': getDayName(currentWeekeendNumber),
          'date': currentDateString,
          'total_daily_amount': 0.0,
          'month_id': getCurrentMonthId()
        },
      );
    } else {
      int savedDay = prefs!.getInt('currentDay')!;

      if (savedDay != _currentDay) {
        print('New day');
        prefs!.setInt('currentDay', _currentDay);
        print('Current date set successfully');

        await db!.insert(
          'Day',
          {
            'day_number': _currentDay,
            'weekend_number': currentWeekeendNumber,
            'day_name': getDayName(currentWeekeendNumber),
            'date': currentDateString,
            'total_daily_amount': 0.0,
            'month_id': getCurrentMonthId()
          },
        );
      } else {
        print('Same day ${getDayName(currentWeekeendNumber)} $_currentDay');
      }
    }

    await getDayTableDataFromDB();
  }

  Future<void> getDayTableDataFromDB() async {
    List<Map<String, dynamic>> maps = await db!.query('Day');

    List<Day> data = maps.map((map) {
      return Day(
        dayId: map['day_id'],
        weekEndNumber: map['weekend_number'],
        dayNumber: map['day_number'],
        dayName: map['day_name'],
        date: map['date'],
        totalDailyAmount: map['total_daily_amount'],
        monthId: map['month_id'],
      );
    }).toList();

    dayTableData = data;
    print('Day table data obtained:');
    print(dayTableData);
  }

  String getMonthName(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  String getDayName(int dayNumber) {
    switch (dayNumber) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  int getCurrentMonthId() {
    monthTableData![monthTableData!.length - 1].monthId;

    return monthTableData![monthTableData!.length - 1].monthId;
  }

  static String getDayMonthYearFormatDate() {
    return DateFormat('dd-MM-yyyy').format(DateTime.now());
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
