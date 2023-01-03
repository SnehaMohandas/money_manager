import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:money_manager_flutter/screens/home/screen_home.dart';

class MoneyManagerBottomNavigation extends StatelessWidget {
  const MoneyManagerBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedIndexNotifier,
      builder: (BuildContext ctx, int updatedIndex, Widget? _) {
        return BottomNavigationBar(
          backgroundColor: Colors.indigo,
          selectedItemColor: Color.fromARGB(255, 236, 232, 233),
          unselectedItemColor: Color.fromARGB(255, 39, 38, 38),
          currentIndex: updatedIndex,
          onTap: (newIndex) {
            ScreenHome.selectedIndexNotifier.value = newIndex;
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Category',
            ),
          ],
        );
      },
    );
  }
}
