import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_gojek_app/components/show_error_dialog.dart';
import 'package:test_gojek_app/models/user_model.dart';
import 'package:test_gojek_app/services/database_helper.dart';
import 'package:test_gojek_app/services/get_box.dart';

class ProfileController extends GetxController {
  // Controllers untuk form
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController ktpCon = TextEditingController();
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController passCon = TextEditingController();

  // State reaktif
  final RxString pathFoto = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool nameActive = false.obs;
  final RxBool ktpActive = false.obs;
  final RxBool emailActive = false.obs;
  final RxBool passActive = false.obs;

  // Database helper
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    isLoading.value = true;
    try {
      int? userId = GetBox().getIdUser();
      if (userId == null) {
        GetDialog.showErrorDialog(
          title: 'Error',
          message: 'User ID tidak ditemukan. Silakan login kembali.',
        );
        Get.offNamed('/login');
        return;
      }

      User? user = await dbHelper.getUser(userId);
      if (user == null) {
        GetDialog.showErrorDialog(
          title: 'Error',
          message: 'Pengguna tidak ditemukan.',
        );
        return;
      }

      nameCon.text = user.namaDriver ?? '';
      ktpCon.text = user.noKtp ?? '';
      emailCon.text = user.email ?? '';
      passCon.text = user.password ?? '';
      pathFoto.value = user.fotoDriver ?? '';
    } catch (e) {
      GetDialog.showErrorDialog(
        title: 'Error',
        message: 'Gagal memuat data: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleName() async {
    if (!nameActive.value) {
      nameActive.value = true;
      return;
    }
    await _updateField('nama_driver', nameCon.text, nameActive);
  }

  Future<void> handleKtp() async {
    if (!ktpActive.value) {
      ktpActive.value = true;
      return;
    }
    await _updateField('no_ktp', ktpCon.text, ktpActive);
  }

  Future<void> handleEmail() async {
    if (!emailActive.value) {
      emailActive.value = true;
      return;
    }
    await _updateField('email', emailCon.text, emailActive);
  }

  Future<void> handlePassword() async {
    if (!passActive.value) {
      passActive.value = true;
      return;
    }
    await _updateField('password', passCon.text, passActive);
  }

  Future<void> _updateField(String field, String value, RxBool active) async {
    isLoading.value = true;
    try {
      int? userId = GetBox().getIdUser();
      if (userId == null) {
        GetDialog.showErrorDialog(
          title: 'Error',
          message: 'User ID tidak ditemukan.',
        );
        return;
      }

      // Validasi
      if (value.isEmpty) {
        GetDialog.showErrorDialog(
          title: 'Error',
          message: '$field tidak boleh kosong.',
        );
        return;
      }

      if (field == 'email' && !GetUtils.isEmail(value)) {
        GetDialog.showErrorDialog(
          title: 'Error',
          message: 'Email tidak valid.',
        );
        return;
      }

      if (field == 'password' && value.length < 6) {
        GetDialog.showErrorDialog(
          title: 'Error',
          message: 'Password minimal 6 karakter.',
        );
        return;
      }

      // Update database
      Map<String, dynamic> updateData = {field: value};
      await dbHelper.database.then((db) => db.update(
        'user',
        updateData,
        where: 'id = ?',
        whereArgs: [userId],
      ));

      active.value = false; // Kembali ke mode tampilan
      Get.snackbar('Sukses', '$field berhasil diperbarui');
    } catch (e) {
      GetDialog.showErrorDialog(
        title: 'Error',
        message: 'Gagal memperbarui $field: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameCon.dispose();
    ktpCon.dispose();
    emailCon.dispose();
    passCon.dispose();
    super.onClose();
  }
}