import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:test_gojek_app/components/show_error_dialog.dart';
import 'package:test_gojek_app/models/user_model.dart';
import 'package:test_gojek_app/routes/route_name.dart';
import 'package:test_gojek_app/services/database_helper.dart';
import 'package:test_gojek_app/services/get_box.dart';

class LoginController extends GetxController {
  TextEditingController emailTextCon = TextEditingController();
  TextEditingController passwordTextCon = TextEditingController();
  final DatabaseHelper _dbService = DatabaseHelper();

  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    bool isFistOpenApp = await GetBox().getFirstOpenApp();
    print('set is: $isFistOpenApp');
    if (isFistOpenApp) {
      print('to set');
      var resdb = await DatabaseHelper().inserDefaultUser();
      await GetBox().setFirstOpenApp(false);
      bool res = await GetBox().getFirstOpenApp();
      print('set: $res\nres db : $resdb');
    }

    // TODO: implement onInit
    super.onInit();
  }

  void loginAction() async {
    isLoading.value = true;
    try {
      String email = emailTextCon.text.trim();
      String password = passwordTextCon.text.trim();

      if (email.isEmpty || password.isEmpty) {
        GetDialog.showErrorDialog(
          title: 'Login Gagal',
          message: 'Email dan password tidak boleh kosong.',
        );
        return;
      }

      User? user = await _dbService.getByEmail(email);

      if (user == null) {
        GetDialog.showErrorDialog(
          title: 'Login Gagal',
          message: 'Email dan password salah.',
        );
      } else if (user.password != password) {
        GetDialog.showErrorDialog(
          title: 'Login Gagal',
          message: 'Email dan password salah.',
        );
      } else {
        clearForm();
        await GetBox().setIdUser(user.id!);
        Get.offNamed(RouteName.splash);
      }
    } catch (e) {
      GetDialog.showErrorDialog(
        title: 'Error',
        message: 'Terjadi kesalahan: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    emailTextCon.text = "";
    passwordTextCon.text = "";
  }

  @override
  void onClose() {
    emailTextCon.dispose();
    passwordTextCon.dispose();
    super.onClose();
  }
}
