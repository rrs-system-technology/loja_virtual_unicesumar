import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_navigation_controller.dart';
import '../views/views.dart';

class MainNavigationPage extends StatelessWidget {
  final MainNavigationController navigationController = Get.put(MainNavigationController());

  MainNavigationPage({super.key});

  final List<Widget> _pages = [
    HomePage(),
    FavoritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _pages[navigationController.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: navigationController.selectedIndex.value,
          onTap: navigationController.changePage,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
            //BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Pedidos'),
            //BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
            //BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
