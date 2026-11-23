import 'package:fin_grow/exception/validation_exception.dart';
import 'package:fin_grow/models/category.dart';
import 'package:fin_grow/models/transaction.dart';
import 'package:fin_grow/models/transaction_type.dart';
import 'package:fin_grow/models/wallet.dart';

class CategoryService {
  final Wallet wallet;

  CategoryService(this.wallet);

  void addCategory({required String categoryName, required TransactionType type}){
    // check empty name
    if(categoryName.trim().isEmpty){
      throw ValidationException("Category name cannot empty!");
    }

    // check duplicate name
    final exist = wallet.categories.any((c) => c.categoryName.toLowerCase() == categoryName.trim().toLowerCase());

    if(exist){
      throw ValidationException("Category already exists!");
    }

    wallet.categories.add(Category(categoryId: wallet.nextId, categoryName: categoryName.trim(), type: type));
  }

  void deleteCategory(String id) {
    // Check whether the category exists
    final category = findCategoryById(id);

    if (category == null) {
      throw ValidationException("Category not found!");
    }

    // Check whether a transaction uses this category
    final usedByTransaction =
        wallet.transactions.any((t) => t.categoryId == id);

    // Check whether a budget uses this category
    final usedByBudget =
        wallet.budgets.any((b) => b.category.categoryId == id);

    if (usedByTransaction || usedByBudget) {
      throw ValidationException(
        "Cannot delete a category that is in use!",
      );
    }

    // Delete the category
    wallet.categories.removeWhere((c) => c.categoryId == id);
  }


  Category? findCategoryById(String id) {
    for (Category category in wallet.categories) {
      if (category.categoryId == id) {
        return category;
      }
    }
    return null;
  }
}