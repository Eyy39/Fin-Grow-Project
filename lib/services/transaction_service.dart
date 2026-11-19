import 'package:fin_grow/models/transaction.dart';
import 'package:fin_grow/models/transaction_type.dart';

class TransactionService{
    List<Transaction> transactions = [];

    void addTransaction({ required String transactionId, required String title, required double amount, String description = '', required TransactionType type, DateTime? date, required String categoryId}){
        if(_findTransactionOrNull(transactionId) != null){
            throw Exception("Transaction $transactionId already exist!");
        }
        if(amount <= 0){
            throw Exception("Amount must be greater than zero");
        }
        transactions.add(Transaction(transactionId: transactionId, title: title, amount: amount, type: type, date: date ?? DateTime.now(), categoryId: categoryId));
    }

    void deleteTransaction(String id){
        if(_findTransactionOrNull(id) == null){
            throw Exception("Transaction not found!");
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
            throw Exception("Transaction not found!");
        }

        // validate before modifying existing data
        if(title.trim().isEmpty){
            throw Exception("Title cannot empty");
        }

        if(amount<=0){
            throw Exception("Amount must be greater than zero!");
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