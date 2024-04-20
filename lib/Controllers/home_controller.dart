import 'dart:async';

import 'package:digital_kharcha_app/Models/transaction_details.dart';
import 'package:digital_kharcha_app/Database/sql.dart';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:telephony/telephony.dart';

class HomeController extends GetxController {
  RxList<TranscationDetails> allTranscationDetailsList =
      <TranscationDetails>[].obs;
  RxList<TranscationDetails> allTodayTranscationDetailsList =
      <TranscationDetails>[].obs;
  RxDouble totalAmountOfToday = 0.0.obs;
  RxDouble totalAmountOfCurrentMonth = 0.0.obs;
  static SqliteService sqliteService = SqliteService();
  Telephony telephony = Telephony.instance;

  void updateDataTimeWise() {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      updateAllData();
      debugPrint('in timer..............');
    });
  }

  void updateAllData() async {
    allTranscationDetailsList.value =
        await sqliteService.getAllTransactionDetailsListFromDatabase();
    addTotalAmountOfToday();
    addTotalAmountOfCurrentMonth();
    getTodayTransactions();
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint("On init");

    connectSQL();

    // Listen for incoming SMS

    connectIncommingMsgs();
  }

// connection to sql
  void connectSQL() async {
    await sqliteService.initializeDB();

    // get transcations in this list
    updateAllData();
    updateDataTimeWise();
  }

  void connectIncommingMsgs() {
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        // Add the new SMS message to the sms list
        // sms.add(message.body.toString());

        addAmountToDB(message: message.body.toString());
      },
      listenInBackground: true,
      onBackgroundMessage: listenInBack,
    );
    debugPrint(
        "Telehone msg listening Connection Done......................................");
  }

  void getTodayTransactions() {
    allTodayTranscationDetailsList.value = [];
    String todayDate = todaysFormattedDate();

    for (TranscationDetails element in allTranscationDetailsList) {
      // print('hellooooooooooooooooooooooo');
      // print(element);
      if (todayDate == element.date) {
        allTodayTranscationDetailsList.add(element);
      }
    }
  }

  void addAmountToDB({required String message}) async {
    String keyword = "debited";
    // message =
    //     "Your a/c no. XXXXXXXX2635 is debited for Rs.41.00 on 28-03-2024 20:32:47 (UPI Ref no 408879605999)";

    // Get.defaultDialog(title: message);
    debugPrint("Message is $message");
    // Check if the message contains the keyword
    if (message.contains(keyword)) {
      // Find the index of the keyword
      int keywordIndex = message.indexOf(keyword);

      // Extract the substring from the keyword to the end of the message
      String amountSubstring = message.substring(keywordIndex);

      // Find the index of 'Rs.' in the substring
      int rsIndex = amountSubstring.indexOf('Rs.');

      // Extract the amount substring starting from 'Rs.'
      String amount = amountSubstring.substring(rsIndex + 3).split(' ')[0];

      debugPrint("Amount debited: Rs.$amount");

      RegExp dateRegex = RegExp(r'\d{2}-\d{2}-\d{4}');
      RegExp timeRegex = RegExp(r'\d{2}:\d{2}:\d{2}');

      String date =
          dateRegex.stringMatch(amountSubstring) ?? ""; // Extract date
      String time =
          timeRegex.stringMatch(amountSubstring) ?? ""; // Extract time

      print("$date              $time");

      // int sizeOfRow =
      await sqliteService.insertTransaction(TranscationDetails(
          // id: 1,
          transactionname: "Tap Here",
          category: "Other",
          time: time,
          amount: amount,
          date: date,
          descriptionWhereUsedTheMoney: message));
      debugPrint("inserted");

      updateAllData();
    } else {
      debugPrint("Keyword 'debited' not found in the message.");
    }
  }

  void addTotalAmountOfToday() {
    String todayDate = todaysFormattedDate();
    totalAmountOfToday.value = 0.0;
    for (TranscationDetails element in allTranscationDetailsList) {
      // print('hellooooooooooooooooooooooo');
      // print(element);
      if (todayDate == element.date) {
        totalAmountOfToday.value += double.parse(element.amount);
      }
    }
  }

  void addTotalAmountOfCurrentMonth() {
    // String todayDate = todaysFormattedDate();
    totalAmountOfCurrentMonth.value = 0.0;
    for (TranscationDetails element in allTranscationDetailsList) {
      // print('hellooooooooooooooooooooooo');
      // print(element);

      totalAmountOfCurrentMonth.value += double.parse(element.amount);
    }
  }

  void updateTransactionName(
      {required String transactionname, required String id}) async {
    await sqliteService.db!.transaction((txn) async {
      await txn.execute(
        "UPDATE AllTransactions "
        "SET transaction_name = '$transactionname'"
        "WHERE id = $id",
      );
    });

    print("Id : $id");
    print(transactionname);
  }

  String todaysFormattedDate() {
    // Get current DateTime
    DateTime now = DateTime.now();

    // Format DateTime to desired format
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);

    return formattedDate;
  }
}

// This function is called when a new SMS is received in the background
void listenInBack(SmsMessage message) async {
  HomeController().addAmountToDB(message: message.body.toString());
}
