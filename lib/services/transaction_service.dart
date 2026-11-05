import 'package:fin_grow/models/transaction.dart';

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

}