import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_gojek_app/constant/AppColors.dart';
import 'common_button.dart';

class GetDialog {
  static void showErrorDialog({
    required String title,
    required String message,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(),
        ),
        actions: [
          CommonButton(
            title: 'OK',
            onPressed: () => Get.back(),
          ),
        ],
        backgroundColor: AppColors.textLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
