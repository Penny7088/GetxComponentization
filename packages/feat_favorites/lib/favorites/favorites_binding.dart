import 'package:get/get.dart';
import 'package:feat_favorites/favorites/favorites_controller.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoritesController());
  }
}
