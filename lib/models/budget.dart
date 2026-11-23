
import 'package:fin_grow/models/category.dart';

class Budget {
  final String budgetId;
  String budgetName;
  double amount;
  final Category category;
  DateTime startDate;
  DateTime endDate;

  Budget({
    required this.budgetId,
    required this.budgetName,
    required this.amount,
    required this.category,
    required this.startDate,
    required this.endDate,
  });
}
