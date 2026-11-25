import 'package:fin_grow/exception/validation_exception.dart';
import 'package:fin_grow/models/budget.dart';
import 'package:fin_grow/models/budget_status.dart';
import 'package:fin_grow/models/wallet.dart';
import 'package:fin_grow/models/transaction.dart';
import 'package:fin_grow/models/transaction_type.dart';
import 'package:fin_grow/models/category.dart';


class BudgetService {
  final Wallet wallet;

  BudgetService({
    required this.wallet,
  });

  // Create a new budget
    
  void createBudget({
    required String budgetName,
    required double amount,
    required String categoryId,
    required DateTime startDate,
    required DateTime endDate,
  }) {

    if (amount <= 0) {
      throw ValidationException('Budget amount must be greater than 0.');
    }

    if (endDate.isBefore(startDate)) {
      throw ValidationException('End date cannot be before start Date.');
    }

    Category? selectedCategory;

    for (final category in wallet.categories) {
      if (category.categoryId == categoryId) {
        selectedCategory = category;

        break;
      }
    }

    if (selectedCategory ==null) {
      throw ValidationException('Category does not exist.');
    }

    // Generate ID

    final budgetId = wallet.nextId;
    final nextNumber = int.tryParse(wallet  .nextId);

    if (nextNumber == null) {
      throw ValidationException('Wallet nextId must be numeric.');
    }

    final budget = Budget(
      budgetId: budgetId, 
      budgetName: budgetName, 
      amount: amount, 
      category: selectedCategory, 
      startDate: startDate, 
      endDate: endDate,
      );
      
      wallet.budgets.add(budget);

      wallet.nextId = (nextNumber + 1).toString();


  }

  // Delete a budget
  void deleteBudget(String budgetId) {
    wallet.budgets.removeWhere((budget)=> budget.budgetId == budgetId,);
  }

  // Calculate total expenses for this budget
  double getSpent(Budget budget) {
    double totalSpent = 0;

    for (final transcation in wallet.transactions) {
      if (budget.appliesTo(transcation)) {
        totalSpent += transcation.amount;
      }
    }
    return totalSpent;
  }

  // calculate remaining budget

  double getRemaining(Budget budget) {
    return budget.amount - getSpent(budget);
  }

  // Determine budget status
  BudgetStatus getStatus(Budget budget) {
    final spent = getSpent(budget);

    if (spent > budget.amount) {
      return BudgetStatus.exceeded;
    }

    else if (spent >= budget.amount) {
      return BudgetStatus.warning;
    }
    else {
      return BudgetStatus.normal;
    }

  }

  // Check whether spending has reached the budget limit
  bool getWarning(Budget budget) {
    return getSpent(budget) >= budget.amount;
  }

  

}