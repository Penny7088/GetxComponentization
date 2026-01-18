import 'package:get/get.dart';

/// A mixin to manage tab selection state in a GetxController.
mixin TabMixin on GetxController {
  final RxInt _selectedIndex = 0.obs;

  int get selectedIndex => _selectedIndex.value;
  set selectedIndex(int value) => _selectedIndex.value = value;

  void onTabChanged(int index) {
    _selectedIndex.value = index;
  }
}
