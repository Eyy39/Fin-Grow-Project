class Budget {
  String id;
  String name;
  double amount;
  double spentAmount;
  String? categoryId;
  DateTime startDate;
  DateTime endDate;

  Budget({
    required this.id, 
    required this.name,
    required this.amount,
    this.spentAmount = 0,
    this.categoryId,
    required this.startDate,
    required this.endDate,

  });

}