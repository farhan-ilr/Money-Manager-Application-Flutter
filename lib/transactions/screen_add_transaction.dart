import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:money_manager_flutter/category/add_category_popup.dart';
import 'package:money_manager_flutter/db/category/category_db.dart';
import 'package:money_manager_flutter/db/transactions/transaction_db.dart';
import 'package:money_manager_flutter/model/catagory/category_model.dart';
import 'package:money_manager_flutter/model/trasaction/transactio_model.dart';

class ScreenAddTransactions extends StatefulWidget {
  static const routeName = 'add-transaction';
  const ScreenAddTransactions({super.key});

  @override
  State<ScreenAddTransactions> createState() => _ScreenAddTransactionsState();
}

class _ScreenAddTransactionsState extends State<ScreenAddTransactions> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;
  String? _selectedCategoryID;

  final _purposeController = TextEditingController();
  final _amountController = TextEditingController();
  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CategoryDB.instance.refreshUI();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                controller: _purposeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'purpose',
                ),
              ),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Amount',
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  final _selectedDateTemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (_selectedDateTemp == null) {
                    return;
                  } else {
                    print(_selectedDateTemp.toString());
                    setState(() {
                      _selectedDate = _selectedDateTemp;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today_sharp),
                label: Text(_selectedDate == null
                    ? 'Select Date'
                    : _selectedDate.toString().trim()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.income,
                        groupValue: _selectedCategoryType,
                        onChanged: (newType) {
                          setState(() {
                            _selectedCategoryType = newType;
                            _selectedCategoryID = null;
                          });
                        },
                      ),
                      Text('Income'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.expense,
                        groupValue: _selectedCategoryType,
                        onChanged: (newType) {
                          setState(() {
                            _selectedCategoryType = newType;
                            _selectedCategoryID = null;
                          });
                        },
                      ),
                      Text('Expense'),
                    ],
                  ),
                ],
              ),
              DropdownButton(
                hint: Text('Selext Category'),
                value: _selectedCategoryID,
                items: (_selectedCategoryType == CategoryType.income
                        ? CategoryDB.instance.incomeCategoryList
                        : CategoryDB.instance.expenseCategoryList)
                    .value
                    .map(
                  (e) {
                    return DropdownMenuItem(
                      onTap: (() {
                        _selectedCategoryModel = e;
                      }),
                      child: Text(e.name),
                      value: e.id,
                    );
                  },
                ).toList(),
                onChanged: (selecteditem) {
                  print(selecteditem.toString());
                  setState(() {
                    _selectedCategoryID = selecteditem.toString();
                  });
                },
                onTap: () {},
              ),
              ElevatedButton(
                onPressed: () {
                  addTransaction();
                },
                child: Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeController.text;
    final _amount = _amountController.text;
    if (_purposeText.isEmpty) {
      return;
    }
    if (_amount.isEmpty) {
      return;
    }
    if (_selectedCategoryID == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }

    final _parsedAmount = double.tryParse(_amount);
    if (_parsedAmount == null) {
      return;
    }

    final _modelTransaction = TransactionModel(
      purpose: _purposeText,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!,
    );

    await TransactionDB.instance.addTransactionDetails(_modelTransaction);
    Navigator.of(context).pop();
    TransactionDB.instance.refresh();
  }
}
