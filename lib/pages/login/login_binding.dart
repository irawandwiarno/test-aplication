import 'package:get/get.dart';
import 'package:test_gojek_app/pages/login/login_controller.dart';

class LoginBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}