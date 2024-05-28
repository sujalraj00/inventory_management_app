import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_statocart/models/product_model.dart';
import 'package:inventory_statocart/widgets/today_sale.dart';
import 'package:inventory_statocart/widgets/view_data.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
            () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Product'),
            NavigationDestination(icon: Icon(Icons.shop), label: 'Sale'),
          ],
        ),
      ),
      body: Obx(() => controller.getCurrentScreen()),
    );
  }
}


class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  SoldItem? soldItem;

  final screens = [
    const SheetDataScreen(),
    SoldDataScreen(soldItem: null),
  ];

  void navigateToSoldDataScreen(SoldItem item) {
    soldItem = item;
    selectedIndex.value = 1;
  }

  Widget getCurrentScreen() {
    if (selectedIndex.value == 1 && soldItem != null) {
      return SoldDataScreen(soldItem: soldItem);
    }
    return screens[selectedIndex.value];
  }
}