import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_flutter/db/category/category_db.dart';

import 'package:money_manager_flutter/db/transactions/transaction_db.dart';
import 'package:money_manager_flutter/model/catagory/category_model.dart';

import '../model/trasaction/transactio_model.dart';

class ScreenTransactions extends StatelessWidget {
  const ScreenTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    CategoryDB.instance.refreshUI();
    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
        return ListView.separated(
            padding: const EdgeInsets.all(10),
            itemBuilder: (ctx, index) {
              final _transaction = newList[index];
              return Slidable(
                startActionPane: ActionPane(
                  motion: DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (ctx) {
                        TransactionDB.instance
                            .deleteTransaction(_transaction.id!);
                        TransactionDB.instance.refresh();
                      },
                      icon: Icons.delete,
                      label: 'Delete',
                    )
                  ],
                ),
                key: Key(_transaction.id!),
                child: Card(
                  color: Colors.grey[300],
                  elevation: 0,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _transaction.type == CategoryType.income
                          ? Colors.green
                          : Colors.red,
                      radius: 50,
                      child: Text(getDate(_transaction.date)),
                    ),
                    title: Text(_transaction.purpose),
                    subtitle: Text(_transaction.amount.toString()),
                  ),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemCount: newList.length);
      },
    );
  }

  String getDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitDate = _date.split(' ');
    return '${_splitDate.last}\n${_splitDate.first}';

    // return '${date.day}\n${date.month}';
  }
}
