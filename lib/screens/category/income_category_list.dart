import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:money_manager_flutter/db/category/category_db.dart';
import 'package:money_manager_flutter/models/category/category_model.dart';

class IncomeCategoryList extends StatelessWidget {
  const IncomeCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDB().incomecategoryListNotifier,
      builder:
          (BuildContext ctx, List<CategoryModel> newIncomeList, Widget? _) {
        return ListView.separated(
            padding: const EdgeInsets.all(5),
            itemBuilder: (ctx, index) {
              final category = newIncomeList[index];
              return Card(
                elevation: 0,
                child: ListTile(
                  title: Text(
                    category.name,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      CategoryDB.instance.deleteCategory(category.id);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Color.fromARGB(255, 155, 21, 21),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return const SizedBox(
                height: 5,
              );
            },
            itemCount: newIncomeList.length);
      },
    );
  }
}
