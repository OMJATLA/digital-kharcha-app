class Day {
  final int dayId;
  final int dayNumber;
  final String dayName;
  final String date;
  final double totalDailyAmount;
  final int monthId;
  final int weekEndNumber;

  Day(
      {required this.dayId,
      required this.dayNumber,
      required this.dayName,
      required this.date,
      required this.totalDailyAmount,
      required this.monthId,
      required this.weekEndNumber});

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      dayId: json['day_id'],
      dayNumber: json['day_number'],
      weekEndNumber: json['weekend_number'],
      dayName: json['day_name'],
      date: json['date'],
      totalDailyAmount: json['total_daily_amount'].toDouble(),
      monthId: json['month_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'day_id': dayId,
        'day_number': dayNumber,
        'day_name': dayName,
        'date': date,
        'total_daily_amount': totalDailyAmount,
        'month_id': monthId,
        'weekend_number': weekEndNumber
      };

  @override
  String toString() {
    return 'Day: $dayName, WeekEnd number: $weekEndNumber Number: $dayNumber, Date: $date, Total Daily Amount: $totalDailyAmount, Month ID: $monthId';
  }
}
