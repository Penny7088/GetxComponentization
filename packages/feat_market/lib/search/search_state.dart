import 'package:lib_base/getx/state/base_state.dart';

class SearchState extends BaseState {
  SearchState() {
    // Initialize state properties here
    isNeedScaffold = true;
    isShowAppBar = true;
    appBarTitle = "Search";
  }

  @override
  void release() {
    // Clean up resources
  }
}
