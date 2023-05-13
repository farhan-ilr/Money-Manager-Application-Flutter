import 'package:flutter/material.dart';
import 'package:money_manager_flutter/db/category/category_db.dart';
import 'package:money_manager_flutter/model/catagory/category_model.dart';

ValueNotifier<CategoryType> selectedCategory =
    ValueNotifier(CategoryType.income);
Future<void> showCategoryAddCategory(BuildContext context) async {
  final _categoryNameController = TextEditingController();
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Add Category'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _categoryNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Category Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  RadioBUtton(title: 'Income', type: CategoryType.income),
                  RadioBUtton(title: 'Expense', type: CategoryType.expense)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  final _name = _categoryNameController.text;
                  if (_name.isEmpty) {
                    return;
                  }
                  final _type = selectedCategory.value;
                  final _category = CategoryModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _name,
                      type: _type);

                  CategoryDB().insertCategory(_category);
                  Navigator.of(ctx).pop();
                },
                child: const Text('Save'),
              ),
            )
          ],
        );
      });
}

class RadioBUtton extends StatelessWidget {
  final String title;
  final CategoryType type;

  const RadioBUtton({Key? key, required this.title, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: selectedCategory,
        builder: (BuildContext context, CategoryType newCategory, Widget? _) {
          return Row(
            children: [
              Radio<CategoryType>(
                  value: type,
                  groupValue: newCategory,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    selectedCategory.value = value;
                    selectedCategory.notifyListeners();
                  }),
              Text(title),
            ],
          );
        });
  }
}
