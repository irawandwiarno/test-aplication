import 'package:get/get.dart';
import 'package:test_gojek_app/pages/profile/profile_controller.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ProfileController());
  }
}
