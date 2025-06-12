import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_gojek_app/constant/AppColors.dart';

class DynamicFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final RxBool active;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback onPressIconForm;
  final VoidCallback onPressIconText;

  DynamicFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.active,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    required this.onPressIconForm,
    required this.onPressIconText,
  }) {
    // Inisialisasi error awal
    _error.value = validator != null ? validator!(controller.text) : null;
    // Tambahkan listener untuk memantau perubahan teks
    controller.addListener(_updateError);
  }

  // State reaktif untuk error
  final RxnString _error = RxnString();

  // Update error saat teks berubah
  void _updateError() {
    _error.value = validator != null ? validator!(controller.text) : null;
    if (onChanged != null) onChanged!(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => active.value
          ? TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            onPressed: onPressIconForm,
            icon:  Icon(
              Icons.done_rounded,
              color: AppColors.textBlack,
            ),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: AppColors.textBlack , width: 2),
          ),
          labelStyle: GoogleFonts.poppins(
            color: AppColors.second,
            fontWeight: FontWeight.w500,
          ),
          errorText: _error.value,
          errorStyle: GoogleFonts.poppins(
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      )
          : Container(
        width: Get.width,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.text.isEmpty
                        ? 'Tidak ada data'
                        : isPassword
                        ? '********'
                        : controller.text,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onPressIconText,
              icon: Icon(
                Icons.edit_outlined,
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}