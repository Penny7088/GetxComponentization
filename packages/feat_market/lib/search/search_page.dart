import 'package:flutter/material.dart';
import 'package:lib_base/getx/view/common_base_view.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:feat_market/search/search_controller.dart' as ctr;

class SearchPage extends CommonBaseView<ctr.SearchController> {
  const SearchPage({super.key});

  @override
  Widget createContentBody({
    required BuildContext context,
    BoxConstraints? constraints,
  }) {
    return Center(child: AppText.heading('Search Page'));
  }
}
