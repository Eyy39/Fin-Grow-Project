import 'package:fin_grow/models/transaction_type.dart';

class Transaction {
  final String transactionId;
  String title;
  double amount;
  TransactionType type;
  String description;
  DateTime date;
  String categoryId;

  Transaction({
    required this.transactionId,
    required this.title,
    required this.amount,
    required this.type,
    this.description = '',
    required this.date,
    required this.categoryId
  });
}
