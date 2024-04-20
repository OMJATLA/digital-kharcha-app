class TranscationDetails {
  int id = 0;
  final String date;
  final String amount;
  final String descriptionWhereUsedTheMoney;
  final String time;
  final String transactionname;
  final String category;

  TranscationDetails({
    required this.date,
    required this.transactionname,
    required this.category,
    required this.time,
    required this.amount,
    required this.descriptionWhereUsedTheMoney,
  });

  @override
  String toString() {
    return "TranscationDetails(id: $id, date: $date, time: $time, transaction_name: $transactionname, category: $category, amount: $amount, descriptionWhereUsedTheMoney: $descriptionWhereUsedTheMoney)";
  }

  TranscationDetails.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        transactionname = map['transaction_name'] ?? "Tap Here",
        category = map['category'] ?? "Other",
        time = map['time'] ?? "Time",
        date = map['date'],
        amount = map['amount'],
        descriptionWhereUsedTheMoney = map['description_where_used_the_money'];

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'transaction_name': transactionname,
      'category': time,
      'amount': amount,
      'description_where_used_the_money': descriptionWhereUsedTheMoney,
    };
  }
}
