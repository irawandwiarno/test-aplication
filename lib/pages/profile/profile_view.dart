import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_gojek_app/components/dynamic_form_field.dart';
import 'package:test_gojek_app/constant/AppColors.dart';
import 'package:test_gojek_app/constant/path_image.dart';
import 'package:test_gojek_app/pages/profile/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  String? validateRequired(String? value) {
    return (value == null || value.isEmpty) ? 'Field tidak boleh kosong' : null;
  }

  String? validateEmail(String? value) {
    return GetUtils.isEmail(value ?? '') ? null : 'Email tidak valid';
  }

  String? validatePassword(String? value) {
    return (value != null && value.length >= 6) ? null : 'Password minimal 6 karakter';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Profile',
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: AppColors.textLight),
        ),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          width: Get.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                CircleAvatar(
                  radius: 70.0, // size: 140.0 / 2
                  backgroundColor: Theme.of(context).colorScheme.primary, // Border color
                  child: CircleAvatar(
                    radius: 68.0, // radius - borderWidth (2.0)
                    backgroundImage: AssetImage(
                      controller.pathFoto.value.isEmpty
                          ? PathImage.NO_PIC
                          : controller.pathFoto.value,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.background,
                    child: controller.pathFoto.value.isEmpty
                        ? Icon(
                      Icons.person,
                      size: 50,
                      color: Theme.of(context).colorScheme.onBackground,
                    )
                        : null,
                  ),
                ),
                const SizedBox(height: 30),
                DynamicFormField(
                  label: 'Nama Driver',
                  controller: controller.nameCon,
                  active: controller.nameActive,
                  validator: (value) => (value == null || value.isEmpty) ? 'Nama tidak boleh kosong' : null,
                  onPressIconForm: controller.handleName,
                  onPressIconText: controller.handleName,
                ),
                const Divider(),
                DynamicFormField(
                  label: 'No. KTP',
                  controller: controller.ktpCon,
                  active: controller.ktpActive,
                  validator: (value) => (value == null || value.isEmpty) ? 'No. KTP tidak boleh kosong' : null,
                  onPressIconForm: controller.handleKtp,
                  onPressIconText: controller.handleKtp,
                ),
                const Divider(),
                DynamicFormField(
                  label: 'Email',
                  controller: controller.emailCon,
                  active: controller.emailActive,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => GetUtils.isEmail(value ?? '') ? null : 'Email tidak valid',
                  onPressIconForm: controller.handleEmail,
                  onPressIconText: controller.handleEmail,
                ),
                const Divider(),
                DynamicFormField(
                  label: 'Password',
                  controller: controller.passCon,
                  active: controller.passActive,
                  isPassword: true,
                  validator: (value) => (value != null && value.length >= 6) ? null : 'Password minimal 6 karakter',
                  onPressIconForm: controller.handlePassword,
                  onPressIconText: controller.handlePassword,
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
