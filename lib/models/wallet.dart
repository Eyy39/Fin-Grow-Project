import 'package:fin_grow/models/budget.dart';
import 'package:fin_grow/models/category.dart';
import 'package:fin_grow/models/saving_goal.dart';
import 'package:fin_grow/models/transaction.dart';

class Wallet {
  List<Category> categories;
  List<Transaction> transactions;
  List<Budget> budgets;
  List<SavingGoal> savingsgoals;
  String nextId;

  Wallet({required this.categories, required this.transactions, required this.budgets, required this.savingsgoals, required this.nextId});
}