import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_gojek_app/components/common_button.dart';
import 'package:test_gojek_app/components/custom_form_auth.dart';
import 'package:test_gojek_app/constant/AppColors.dart';
import 'package:test_gojek_app/constant/path_image.dart';
import 'package:test_gojek_app/pages/login/login_controller.dart';
import 'package:test_gojek_app/services/get_box.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gojek',
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w800, color: AppColors.textLight),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          width: Get.width,
          height: Get.height,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                ),
                Text(
                  'Login',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 30),
                ),
                SizedBox(
                  height: 30,
                ),
                Image.asset(
                  PathImage.LOGIN2,
                  scale: 1.2,
                ),
                SizedBox(
                  height: 40,
                ),
                CustomFormAuth(
                    label: "Email",
                    icon: Icons.person,
                    controller: controller.emailTextCon),
                SizedBox(
                  height: 20,
                ),
                CustomFormAuth(
                    label: "Password",
                    icon: Icons.remove_red_eye,
                    controller: controller.passwordTextCon),
                SizedBox(
                  height: 20,
                ),
                Obx(
                  () => CommonButton(
                    title: "Login",
                    onPressed: controller.loginAction,
                    isLoading: controller.isLoading.value,
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
