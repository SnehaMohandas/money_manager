import 'package:flutter/material.dart';
import 'package:money_manager_flutter/db/category/category_db.dart';
import 'package:money_manager_flutter/models/category/category_model.dart';
import 'package:money_manager_flutter/screens/add_transaction/screen_add_transactions.dart';
import 'package:money_manager_flutter/screens/category/category_add_popup.dart';
import 'package:money_manager_flutter/screens/category/screen_category.dart';
import 'package:money_manager_flutter/screens/home/widgets/bottom_navigation.dart';
import 'package:money_manager_flutter/screens/transactions/screen_transactions.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  final _pages = const [ScreenTransaction(), ScreenCategory()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('MONEY MANAGER'),
        centerTitle: true,
      ),
      bottomNavigationBar: const MoneyManagerBottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedIndexNotifier,
          builder: (BuildContext ctx, int updatedIndex, Widget? _) {
            return _pages[updatedIndex];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndexNotifier.value == 0) {
            Navigator.of(context).pushNamed(ScreenAddTransactions.routeName);
          } else {
            showCategoryAddPopup(context);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
