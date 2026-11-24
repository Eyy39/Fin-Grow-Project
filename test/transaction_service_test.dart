import 'package:fin_grow/models/transaction_type.dart';
import 'package:fin_grow/models/wallet.dart';
import 'package:fin_grow/services/category_service.dart';
import 'package:fin_grow/services/transaction_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TransactionService service;

  setUp(() {
    service = TransactionService();
  });

  group('TransationService test', () {
    // Add a valid expense
    test('Add valid expense', () {
      service.addTransaction(
        transactionId: 'T001',
        title: 'Lunch',
        amount: 5,
        type: TransactionType.expense,
        categoryId: 'C001',
      );
    });

    final result = service.getHistory();
    expect(result.length, 1);
    expect(result.first.amount, 5);
    expect(result.first.title, 'Lunch');
  });

  // reject zero amount
  test('Reject zero amount', () {
    expect(
      () => service.addTransaction(
        transactionId: 'T002',
        title: 'Lunch',
        amount: 0,
        type: TransactionType.expense,
        categoryId: 'C001',
      ),
      throwsException,
    );
    expect(service.getHistory(), isEmpty);
  });

  // Reject negative amount
  test('Reject negative amount', () {
    expect(
      () => service.addTransaction(
        transactionId: 'T003',
        title: 'Lunch',
        amount: -5,
        type: TransactionType.expense,
        categoryId: 'C001',
      ),
      throwsException,
    );
    expect(service.getHistory(), isEmpty);
  });

  // Reject invalid category
  test('Reject invalid category', () {
    expect(
      () => service.addTransaction(
        transactionId: 'T004',
        title: 'Lunch',
        amount: 6,
        type: TransactionType.expense,
        categoryId: 'INVALID',
      ),
      throwsException,
    );
    expect(service.getHistory(), isEmpty);
  });
  // Update a transaction
  test('Update a transaction', () {
    service.addTransaction(
      transactionId: 'TR005',
      title: 'Lunch',
      amount: 100,
      type: TransactionType.expense,
      categoryId: 'CAT001',
    );

    service.updateTransaction(
      transactionId: 'TR005',
      title: 'Dinner',
      amount: 200,
      type: TransactionType.expense,
      categoryId: 'CAT001',
    );

    final result = service.getHistory();

    expect(result.length, 1);
    expect(result.first.title, 'Dinner');
    expect(result.first.amount, 200);
  });
}
