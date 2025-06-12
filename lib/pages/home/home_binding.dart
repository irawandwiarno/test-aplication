
import 'package:get/get.dart';
import 'package:test_gojek_app/pages/home/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(HomeController(), permanent: true);
 }
}