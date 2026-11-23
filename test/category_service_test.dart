import 'package:fin_grow/models/wallet.dart';
import 'package:fin_grow/services/category_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fin_grow/models/transaction_type.dart';
import 'package:fin_grow/exception/validation_exception.dart';

void main() {
  late CategoryService service;
  late Wallet wallet;

  setUp(() {
    wallet = Wallet(
      categories: [],
      transactions: [],
      budgets: [],
      savingsgoals: [],
      nextId: '1',
    );
    service = CategoryService(wallet);
    service.addCategory(categoryName: 'Food', type: TransactionType.expense);

    service.addCategory(
      categoryName: 'Transport',
      type: TransactionType.expense,
    );
  });

  group('CategoryService Tests', () {
    // Reject duplicate and empty names
    test('Reject duplicate and empty category names', () {
      expect(
        () => service.addCategory(
          categoryName: 'Food',
          type: TransactionType.expense,
        ),
        throwsException,
      );

      expect(
        () => service.addCategory(
          categoryName: 'food',
          type: TransactionType.expense,
        ),
        throwsException,
      );

      expect(
        () => service.addCategory(
          categoryName: '   ',
          type: TransactionType.expense,
        ),
        throwsException,
      );
    });

    // Cannot delete category used by a transaction
    // Requires CategoryService to check transaction references.
    test('Cannot delete a category used by a transaction', () {});

    // Delete an unused category
    test('Delete an unused category', () {
      service.addCategory(
        categoryName: 'Travel',
        type: TransactionType.expense,
      );

      final travel = service.findCategoryById(wallet.categories.last.categoryId);

      expect(travel, isNotNull);

      service.deleteCategory(travel!.categoryId);

      expect(service.findCategoryById(travel.categoryId), isNull);
    });
  });
}
