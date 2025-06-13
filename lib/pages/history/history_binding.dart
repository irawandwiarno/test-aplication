import 'package:get/get.dart';
import 'package:test_gojek_app/pages/history/history_controller.dart';

class HistoryBinding implements Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(HistoryController());
  }
}