import 'package:flutter/material.dart';
import 'package:money_manager_flutter/category/add_category_popup.dart';
import 'package:money_manager_flutter/category/screen_category.dart';
import 'package:money_manager_flutter/home/widgets/bottom_navigation.dart';
import 'package:money_manager_flutter/transactions/screen_add_transaction.dart';
import 'package:money_manager_flutter/transactions/screen_transactions.dart';

import '../db/transactions/transaction_db.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  static ValueNotifier<int> selectedindexNotifier = ValueNotifier(0);
  final _pages = const [ScreenTransactions(), ScreenCategory()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MONEY MANAGER'),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: const MoneyManagerBottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: selectedindexNotifier,
            builder: (BuildContext context, int updatedIndex, _) {
              return _pages[updatedIndex];
            }),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (selectedindexNotifier.value == 0) {
              Navigator.of(context).pushNamed(ScreenAddTransactions.routeName);
            } else {
              showCategoryAddCategory(context);
            }
          },
          child: const Icon(Icons.add_box_sharp)),
    );
  }
}
