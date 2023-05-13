import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:money_manager_flutter/category/screen_category.dart';
import 'package:money_manager_flutter/home/screen_home.dart';

class MoneyManagerBottomNavigation extends StatelessWidget {
  const MoneyManagerBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedindexNotifier,
      builder: (BuildContext ctx, int updatedIndex, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BottomNavigationBar(
              backgroundColor: Colors.blue,
              selectedItemColor: Color.fromARGB(255, 0, 0, 0),
              unselectedItemColor: Color.fromARGB(255, 255, 253, 253),
              currentIndex: updatedIndex,
              onTap: (newIndex) {
                ScreenHome.selectedindexNotifier.value = newIndex;
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category),
                  label: 'Category',
                ),
              ]),
        );
      },
    );
  }
}
