class Year {
  int year;
  double yearlyAmount;

  Year({required this.year, required this.yearlyAmount});

  factory Year.fromMap(Map<String, dynamic> map) {
    return Year(
      year: map['year'],
      yearlyAmount: map['yearly_amount'],
    );
  }
}
