import 'package:fin_grow/exception/validation_exception.dart';
import 'package:fin_grow/models/transaction.dart';
import 'package:fin_grow/models/transaction_type.dart';
import 'package:fin_grow/models/wallet.dart';

class TransactionService{
    final List<Transaction> transactions = [];
    final Wallet wallet;

    TransactionService(this.wallet);

    void addTransaction({ required String transactionId, required String title, required double amount, String description = '', required TransactionType type, DateTime? date, required String categoryId}){
        if(_findTransactionOrNull(transactionId) != null){
            throw ValidationException("Transaction $transactionId already exist!");
        }
        if(amount <= 0){
            throw ValidationException("Amount must be greater than zero");
        }
        // check category exists
        if(!wallet.categories.any((category)=> category.categoryId == categoryId)){
          throw ValidationException("Category not found!");
        }
        transactions.add(Transaction(transactionId: transactionId, title: title, amount: amount, type: type, date: date ?? DateTime.now(), categoryId: categoryId));
    }

    void deleteTransaction(String id){
        if(_findTransactionOrNull(id) == null){
            throw ValidationException("Transaction not found!");
        }
        transactions.removeWhere((t)=> t.transactionId == id);
    }

    Transaction? _findTransactionOrNull(String id){
        for(Transaction t in transactions){
            if(t.transactionId == id) return t;
        }
        return null;
    }

    void updateTransaction({required String transactionId, required String title, required double amount, required TransactionType type, required String categoryId, DateTime? date, String description = ''}){
        final transaction = _findTransactionOrNull(transactionId);
        if(transaction == null){
            throw ValidationException("Transaction not found!");
        }

        // validate before modifying existing data
        if(title.trim().isEmpty){
            throw ValidationException("Title cannot empty");
        }

        if(amount<=0){
            throw ValidationException("Amount must be greater than zero!");
        }

        transaction.title = title;
        transaction.amount = amount;
        transaction.type = type;
        transaction.categoryId = categoryId;
        transaction.description = description;

        if(date != null){
            transaction.date = date;
        }
    }

    List<Transaction> getHistory({
        DateTime? startDate,
        DateTime? endDate,
        TransactionType? type,
        String? categoryId,
    }) {
        List<Transaction> result = transactions.where((t) {
        final transactionDate = DateTime(
            t.date.year,
            t.date.month,
            t.date.day,
        );

        final start = startDate == null
            ? null
            : DateTime(startDate.year, startDate.month, startDate.day);

        final end = endDate == null
            ? null
            : DateTime(endDate.year, endDate.month, endDate.day);

        return (start == null || !transactionDate.isBefore(start)) &&
            (end == null || !transactionDate.isAfter(end)) &&
            (type == null || t.type == type) &&
            (categoryId == null || t.categoryId == categoryId);
        }).toList();
        result.sort((a, b) => b.date.compareTo(a.date));

        return result;
    }

}