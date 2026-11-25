
import 'package:fin_grow/models/category.dart';
import 'package:fin_grow/models/transaction.dart';
import 'package:fin_grow/models/transaction_type.dart';

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

  bool appliesTo(Transaction transaction) {
    final transactionDate = DateTime(
      transaction.date.year,
      transaction.date.month,
      transaction.date.day,
    );

    final start = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );

    final end = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
    );

    return transaction.type == TransactionType.expense && transaction.categoryId == category.categoryId && !transactionDate.isBefore(start) && !transactionDate.isAfter(end);

  }
}
