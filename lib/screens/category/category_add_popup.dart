import 'package:flutter/material.dart';
import 'package:money_manager_flutter/db/category/category_db.dart';
import 'package:money_manager_flutter/models/category/category_model.dart';

ValueNotifier<CategoryType> selectedCategoryTypeNotifier =
    ValueNotifier(CategoryType.income);

Future<void> showCategoryAddPopup(BuildContext context) async {
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
                  border: OutlineInputBorder(), hintText: 'Category Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                RadioButton(title: 'Income', type: CategoryType.income),
                RadioButton(title: 'Expense', type: CategoryType.expense),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                final _categoryName = _categoryNameController.text;
                if (_categoryName.isEmpty) {
                  return;
                }
                final _type = selectedCategoryTypeNotifier.value;
                final _category = CategoryModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _categoryName,
                  type: _type,
                );

                CategoryDB().insertCategory(_category);
                //CategoryDB.instance.insertCategory(_category);
                Navigator.of(context).pop(ctx);
              },
              child: const Text('Add'),
            ),
          ),
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;

  const RadioButton({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: selectedCategoryTypeNotifier,
            builder: (BuildContext ctx, CategoryType newType, Widget? _) {
              return Radio<CategoryType>(
                  value: type,
                  groupValue: selectedCategoryTypeNotifier.value,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    selectedCategoryTypeNotifier.value = value;

                    selectedCategoryTypeNotifier.notifyListeners();
                  });
            }),
        Text(title),
      ],
    );
  }
}
