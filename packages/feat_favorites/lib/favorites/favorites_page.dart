import 'package:flutter/material.dart';
import 'package:lib_base/getx/view/common_base_view.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:feat_favorites/favorites/favorites_controller.dart';

class FavoritesPage extends CommonBaseView<FavoritesController> {
  const FavoritesPage({super.key});

  @override
  Widget createContentBody({
    required BuildContext context,
    BoxConstraints? constraints,
  }) {
    return Center(child: AppText.heading('Favorites Page'));
  }
}
