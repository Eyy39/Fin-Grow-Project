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

  
}
