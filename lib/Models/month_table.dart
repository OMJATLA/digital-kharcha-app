class Month {
  final int monthId;
  final String monthName;
  final int monthNumber;
  final double totalMonthlyAmount;
  final int yearId;
  final String date;

  Month({
    required this.monthId,
    required this.monthName,
    required this.monthNumber,
    required this.totalMonthlyAmount,
    required this.date,
    required this.yearId,
  });

  factory Month.fromJson(Map<String, dynamic> json) {
    return Month(
      date: json['date'],
      monthId: json['month_id'],
      monthName: json['month_name'],
      monthNumber: json['month_number'],
      totalMonthlyAmount: json['total_monthly_amount'].toDouble(),
      yearId: json['year_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'month_id': monthId,
        'month_name': monthName,
        'month_number': monthNumber,
        'date': date,
        'total_monthly_amount': totalMonthlyAmount,
        'year': yearId,
      };

  @override
  String toString() {
    return 'Month: $monthName, Month Number: $monthNumber, Total Monthly Amount: $totalMonthlyAmount, Year_ID: $yearId, Date: $date, Month id : $monthId';
  }
}
