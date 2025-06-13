import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_gojek_app/components/common_button.dart';
import 'package:test_gojek_app/components/dynamic_form_field.dart';
import 'package:test_gojek_app/constant/AppColors.dart';
import 'package:test_gojek_app/constant/path_image.dart';
import 'package:test_gojek_app/pages/profile/profile_controller.dart';
import 'package:test_gojek_app/services/get_box.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  String? validateKtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'No. KTP tidak boleh kosong';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'No. KTP harus berisi angka saja';
    }
    // Opsional: Validasi panjang KTP (16 digit)
    if (value.length != 16) {
      return 'No. KTP harus 16 digit';
    }
    return null;
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
              fontSize: 20,
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
                        radius: 68.0,
                        backgroundColor: Colors.grey,
                        backgroundImage: controller.pathFoto.value.isEmpty
                            ? AssetImage(PathImage.NO_PIC)
                            : FileImage(File(controller.pathFoto.value))
                                as ImageProvider,
                      ),
                      TextButton(
                          onPressed: controller.updateProfilePhoto,
                          child: Text(
                            'Edit Foto',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                color: Colors.blue),
                          )),
                      const SizedBox(height: 30),
                      DynamicFormField(
                        label: 'Nama Driver',
                        controller: controller.nameCon,
                        active: controller.nameActive,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Nama tidak boleh kosong'
                            : null,
                        onPressIconForm: controller.handleName,
                        onPressIconText: controller.handleName,
                      ),
                      const Divider(),
                      DynamicFormField(
                        label: 'No. KTP',
                        controller: controller.ktpCon,
                        active: controller.ktpActive,
                        keyboardType: TextInputType.number,
                        validator: validateKtp,
                        onPressIconForm: controller.handleKtp,
                        onPressIconText: controller.handleKtp,
                      ),
                      const Divider(),
                      DynamicFormField(
                        label: 'Email',
                        controller: controller.emailCon,
                        active: controller.emailActive,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => GetUtils.isEmail(value ?? '')
                            ? null
                            : 'Email tidak valid',
                        onPressIconForm: controller.handleEmail,
                        onPressIconText: controller.handleEmail,
                      ),
                      const Divider(),
                      DynamicFormField(
                        label: 'Password',
                        controller: controller.passCon,
                        active: controller.passActive,
                        isPassword: false,
                        onPressIconForm: controller.handlePassword,
                        onPressIconText: controller.handlePassword,
                      ),
                      const Divider(),
                      SizedBox(height: 30,),
                      CommonButton(
                          title: "Logout", onPressed: () => controller.logout())
                    ],
                  ),
                ),
              ),
            )),
    );
  }
}
