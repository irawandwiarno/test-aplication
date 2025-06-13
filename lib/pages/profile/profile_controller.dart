import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:test_gojek_app/components/show_error_dialog.dart';
import 'package:test_gojek_app/constant/AppColors.dart';
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

  final ImagePicker _picker = ImagePicker();

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

  Future<void> updateProfilePhoto() async {
    isLoading.value = true;
    try {

      final ImageSource? source = await _showImageSourceDialog();
      if (source == null) {
        isLoading.value = false;
        return;
      }

      Permission permission;
      String permissionType;
      if (source == ImageSource.camera) {
        permission = Permission.camera;
        permissionType = 'kamera';
      } else {
        permission = Permission.photos;
        permissionType = 'galeri';
      }

      final status = await permission.status;
      print('Status izin $permissionType awal: $status');
      if (status.isGranted) {
        print('Izin $permissionType sudah diberikan');
      } else if (status.isPermanentlyDenied) {
        print('Izin $permissionType diblokir permanen');
        GetDialog.showErrorDialog(
          title: 'Izin Diblokir',
          message:
              'Izin $permissionType diblokir. Buka pengaturan aplikasi untuk mengizinkan.',
          onConfirm: () => openAppSettings(),
        );
        return;
      } else {
        final newStatus = await permission.request();
        print(
            'Status izin $permissionType setelah request: $newStatus'); // Debugging

        if (!newStatus.isGranted && permissionType == 'kamera') {
          if (newStatus.isPermanentlyDenied) {
            GetDialog.showErrorDialog(
              title: 'Izin Diblokir',
              message:
                  'Izin $permissionType diblokir. Buka pengaturan aplikasi untuk mengizinkan.',
              onConfirm: () => openAppSettings(),
            );
          } else {
            GetDialog.showErrorDialog(
              title: 'Izin Ditolak',
              message: 'Izin $permissionType diperlukan.',
            );
          }
          return;
        }
      }

      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) {
        isLoading.value = false;
        return;
      }

      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory profileDir =
          Directory(path.join(appDir.path, 'image', 'profile'));

      if (!await profileDir.exists()) {
        await profileDir.create(recursive: true);
      }

      final String fileName =
          'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String newPath = path.join(profileDir.path, fileName);

      await File(image.path).copy(newPath);

      int? userId = GetBox().getIdUser();
      if (userId == null) {
        GetDialog.showErrorDialog(
          title: 'Error',
          message: 'User ID tidak ditemukan.',
        );
        return;
      }

      if (pathFoto.value.isNotEmpty && await File(pathFoto.value).exists()) {
        await File(pathFoto.value).delete();
      }

      await dbHelper.database.then((db) => db.update(
            'user',
            {'foto_driver': newPath},
            where: 'id = ?',
            whereArgs: [userId],
          ));

      pathFoto.value = newPath;

      Get.snackbar(
        'Sukses',
        'Foto profil berhasil diperbarui',
        backgroundColor: AppColors.primary,
        colorText: AppColors.textLight,
      );
    } catch (e) {
      GetDialog.showErrorDialog(
        title: 'Error',
        message: 'Gagal memperbarui foto profil: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return await Get.bottomSheet<ImageSource>(
      Container(
        color: AppColors.textLight,
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.primary),
              title: Text('Galeri', style: TextStyle(color: AppColors.primary)),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.primary),
              title: Text('Kamera', style: TextStyle(color: AppColors.primary)),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
          ],
        ),
      ),
    );
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

      Map<String, dynamic> updateData = {field: value};
      await dbHelper.database.then((db) => db.update(
            'user',
            updateData,
            where: 'id = ?',
            whereArgs: [userId],
          ));

      active.value = false; // Kembali ke mode tampilan
      Get.snackbar('Sukses', '$field berhasil diperbarui',
          backgroundColor: AppColors.textLight);
    } catch (e) {
      GetDialog.showErrorDialog(
        title: 'Error',
        message: 'Gagal memperbarui $field: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _showLogoutConfirmationDialog() async {
    bool? confirmed = await GetDialog.showConfirmationDialog(
      title: 'Konfirmasi Logout',
      message: 'Apakah Anda yakin ingin logout?',
      confirmText: 'Ya',
      cancelText: 'Batal',
      icon: Icons.exit_to_app
    );
    return confirmed ?? false;
  }

  void logout() async {
    final bool confirmed = await _showLogoutConfirmationDialog();
    if (!confirmed) return;

    try {
      final bool res = await GetBox().deleteIdUser();
      if (res) {
        Get.snackbar(
          'Sukses',
          'Logout berhasil, Anda akan diarahkan ke halaman login',
          backgroundColor: AppColors.primary,
          colorText: AppColors.textLight,
          duration: Duration(seconds: 3),
        );
        await Future.delayed(Duration(seconds: 1));
        Get.offAllNamed('/login');
      } else {
        throw Exception('Gagal menghapus data pengguna');
      }
    } catch (e) {
      print('Error saat logout: $e');
      GetDialog.showErrorDialog(
        title: 'Error',
        message: 'Gagal logout: $e',
      );
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
