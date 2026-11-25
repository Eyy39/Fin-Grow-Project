import 'package:flutter_test/flutter_test.dart';

import 'package:fin_grow/models/budget.dart';
import 'package:fin_grow/models/budget_status.dart';
import 'package:fin_grow/models/wallet.dart';
import 'package:fin_grow/models/category.dart';
import 'package:fin_grow/models/transaction.dart';
import 'package:fin_grow/models/transaction_type.dart';

import 'package:fin_grow/services/budget_service.dart';
import 'package:fin_grow/services/transaction_service.dart';
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

  // test('Create a valid budget', () {
  //   final wallet = createWallet();
  //   final budgetService = BudgetService(wallet: wallet);

  //   budgetService.createBudget(
  //     budgetName: 'Food Budget', 
  //     amount: 10000, 
  //     categoryId: 'C1', 
  //     startDate: DateTime(2026, 11, 1), 
  //     endDate: DateTime(2026, 12, 1),
  //     );

  //   expect(wallet.budgets.length, 1);
  // });


  // test('create transaction', () {
    
  //   final transactionService = TransactionService();

  //   transactionService.addTransaction(
  //     transactionId: 'T1', 
  //     title: 'Lunch', 
  //     amount: 500, 
  //     type: TransactionType.expense, 
  //     categoryId: 'C1',
  //     );

  //   expect(transactionService.transactions.length, 1);
  //   expect(transactionService.transactions.first.transactionId, 'T1');
  //   expect(transactionService.transactions.first.title, 'Lunch');
  //   expect(transactionService.transactions.first.amount, 500);

  //   expect(transactionService.transactions.first.type, TransactionType.expense);
  // });

  // Create a Budget for testing
  Budget createTestBudget(
    BudgetService service, {
      double amount = 1000,
      String categoryId = 'C1',
      DateTime? startDate,
      DateTime? endDate,
    }
  ) {
    service.createBudget(
      budgetName: 'Food Budget', 
      amount: amount, 
      categoryId: categoryId, 
      startDate: startDate ?? DateTime(2026, 11, 1), 
      endDate: endDate ?? DateTime(2026, 12, 1),
      );
      return service.wallet.budgets.last;
  }

  // Create a transaction for testing 
  Transaction createTransaction({
    required String id,
    required double amount,
    required TransactionType type,
    required String categoryId,
    required DateTime date,
  }) {
    return Transaction(
      transactionId: id, 
      title: 'Test Transaction', 
      amount: amount, 
      type: type, 
      date: date, 
      categoryId: categoryId,
      );
  }

  group('BudgetService Tests', () {

    // Test 1: Zero / negative budget is rejected
    test('Reject zero and negative budget amounts', (){
      final wallet = createWallet();
      final service = BudgetService(wallet: wallet);

      expect(
        () => createTestBudget(service, amount: -100), 
        throwsA(isA<ValidationException>()),
      );
    });

    // Test 2: Reject invalid date range
    test('Reject end date before start date', (){
      final wallet = createWallet();
      final service = BudgetService(wallet: wallet);


      expect(
        () => createTestBudget(
          service,
          startDate: DateTime(2026, 12, 20),
          endDate: DateTime(2026, 11,5),
        ),
        throwsA(isA<ValidationException>()),
        );
    });

    // Test 3: Calculate spent and remaining

    test('Calculate spent and remaining', (){
      final wallet = createWallet();
      final service = BudgetService(wallet: wallet);
      final budget = createTestBudget(service);

      wallet.transactions.addAll([
        createTransaction(
          id: 'T1', 
          amount: 200, 
          type: TransactionType.expense, 
          categoryId: 'C1', 
          date: DateTime(2026, 11, 7),
          ),
        createTransaction(
          id: 'T2', 
          amount: 300, 
          type: TransactionType.expense, 
          categoryId: 'C1', 
          date: DateTime(2026, 11, 12),
          ),
        createTransaction(
          id: 'T3', 
          amount: 150, 
          type: TransactionType.expense, 
          categoryId: 'C1', 
          date: DateTime(2026, 11, 18),
          ),
      ]);

      expect(service.getSpent(budget), 650);
      expect(service.getRemaining(budget), 350);
      expect(service.getStatus(budget), BudgetStatus.normal);
    });

    // Test 4: spending exactly reach the limit
    test('Show warning when spending reaches budget limit', () {
      final wallet = createWallet();
      final service = BudgetService(wallet: wallet);
      final budget = createTestBudget(service);

      wallet.transactions.add(
        createTransaction(
          id: 'T1', 
          amount: 1000, 
          type: TransactionType.expense, 
          categoryId: 'C1', 
          date: DateTime(2026, 11, 18),
          ),
      );
      expect(service.getSpent(budget), 1000);
      expect(service.getStatus(budget), BudgetStatus.warning);
      expect(service.getWarning(budget), true);
    });

    // Test 5: spending exceeds the limit
    test('Show exceed when spending is above budget limit', () {
      final wallet = createWallet();
      final service = BudgetService(wallet: wallet);
      final budget = createTestBudget(service);

      wallet.transactions.add(
        createTransaction(
          id: 'T1', 
          amount: 1200, 
          type: TransactionType.expense, 
          categoryId: 'C1', 
          date: DateTime(2026, 11, 18),
          ),
      );
      expect(service.getSpent(budget), 1200);
      expect(service.getRemaining(budget), -200);
      expect(service.getStatus(budget), BudgetStatus.exceeded);
      expect(service.getWarning(budget), true);
    });
  });

}