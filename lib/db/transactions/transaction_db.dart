import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager_flutter/model/trasaction/transactio_model.dart';

const TRANSACTION_DB_NAME = 'transaction-db';

abstract class TransactionDBFunctions {
  Future<void> addTransactionDetails(TransactionModel model);
  Future<List<TransactionModel>> getTransactions();
  Future<void> deleteTransaction(String id);
}

class TransactionDB implements TransactionDBFunctions {
  TransactionDB._internal();

  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionNotifier = ValueNotifier([]);

  @override
  Future<void> addTransactionDetails(TransactionModel model) async {
    final _trDB = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    _trDB.put(model.id, model);
  }

  Future<void> refresh() async {
    final _allTransactions = await getTransactions();
    _allTransactions.sort((first, second) => second.date.compareTo(first.date));
    transactionNotifier.value.clear();
    transactionNotifier.value.addAll(_allTransactions);
    transactionNotifier.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final _trDB = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return _trDB.values.toList();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final _trDB = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _trDB.delete(id);
  }
}
