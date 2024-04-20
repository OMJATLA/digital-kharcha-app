class Year {
  int yearId;
  double yearlyAmount;

  Year({required this.yearId, required this.yearlyAmount});
  @override
  String toString() => "year : $yearId, yearlyAmount :  $yearlyAmount";

  factory Year.fromMap(Map<String, dynamic> map) {
    return Year(
      yearId: map['year_id'],
      yearlyAmount: map['yearly_amount'],
    );
  }
}
