import 'package:fin_grow/models/transaction_type.dart';

class Category{
    final String categoryId;
    String categoryName;
    TransactionType type;

    Category({required this.categoryId, required this.categoryName, required this.type});
}