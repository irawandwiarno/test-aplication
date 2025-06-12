import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test_gojek_app/constant/AppColors.dart';

class CustomFormAuth extends StatefulWidget {
  final String label;
  final IconData icon;
  final ValueChanged<String>? onChanged;
  final TextEditingController controller;

  const CustomFormAuth({
    Key? key,
    required this.label,
    required this.icon,
    this.onChanged,
    required this.controller,
  }) : super(key: key);

  @override
  _CustomFormAuthState createState() => _CustomFormAuthState();
}

class _CustomFormAuthState extends State<CustomFormAuth> {
  bool _obscureText = true;

  // Fungsi validasi email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    bool isEmail = widget.label.toLowerCase() == 'email';
    bool isPassword = widget.label.toLowerCase() == 'password';

    return TextField(
      controller: widget.controller,
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!(value); // Panggil onChanged jika tidak null
        }
        setState(() {});
      },
      obscureText: isPassword ? _obscureText : false,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : Icon(widget.icon),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: AppColors.primary, width: 2)),
        errorText: isEmail && widget.controller.text.trim() != ""
            ? _validateEmail(widget.controller.text)
            : null,
      ),
    );
  }
}
