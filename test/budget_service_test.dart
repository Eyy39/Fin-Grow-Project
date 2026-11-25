import 'package:flutter_test/flutter_test.dart';

import 'package:fin_grow/models/budget.dart';
import 'package:fin_grow/models/budget_status.dart';
import 'package:fin_grow/models/wallet.dart';
import 'package:fin_grow/models/category.dart';
import 'package:fin_grow/models/transaction.dart';
import 'package:fin_grow/models/transaction_type.dart';

import 'package:fin_grow/services/budget_service.dart';
import 'package:fin_grow/exception/validation_exception.dart';


void main() {
  Wallet createWallet() {
    final food = Category(
      categoryId: 'C1', 
      categoryName: 'Food', 
      type: TransactionType.expense,
    );

    final transport = Category(
      categoryId: 'C2', 
      categoryName: 'Transport', 
      type: TransactionType.expense,

    );

    return Wallet(
      categories: [food, transport], 
      transactions: [], 
      budgets: [], 
      savingsgoals: [], 
      
      nextId: '1',
    );
  }

  test('Create a valid budget', () {
    final wallet = createWallet();
    final budgetService = BudgetService(wallet: wallet);

    budgetService.createBudget(
      budgetName: 'Food Budget', 
      amount: 10000, 
      categoryId: 'C1', 
      startDate: DateTime(2026, 11, 1), 
      endDate: DateTime(2026, 12, 1),
      );

    expect(wallet.budgets.length, 1);
  });

  
}