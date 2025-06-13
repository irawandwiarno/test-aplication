import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_gojek_app/components/show_error_dialog.dart';
import 'package:test_gojek_app/constant/AppColors.dart';
import 'package:test_gojek_app/models/delivery_model.dart';
import 'package:test_gojek_app/pages/history/history_controller.dart';
import 'package:test_gojek_app/services/database_helper.dart';
import 'package:test_gojek_app/services/get_box.dart';

class HomeController extends GetxController {
  final fotoBarang = Rxn<File>();

  final latAController = TextEditingController();
  final lngAController = TextEditingController();
  final latBController = TextEditingController();
  final lngBController = TextEditingController();
  final ongkosController = TextEditingController();

  final jarakKm = 0.0.obs;
  final ongkosText = ''.obs;
  final ongkosRaw = 0.obs;

  final ImagePicker _picker = ImagePicker();
  final dbHelper = DatabaseHelper();
  final hc = Get.find<HistoryController>();

  // =====================================
  // FOTO BARANG
  // =====================================
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

  void pickFoto() async {
    final ImageSource? source = await _showImageSourceDialog();
    if (source == null) {
      GetDialog.showErrorDialog(title: "Gagal", message: "Gagal mengambil foto");
      return;
    }

    final permission = (source == ImageSource.camera)
        ? Permission.camera
        : Permission.photos;
    final permissionType = (source == ImageSource.camera) ? 'kamera' : 'galeri';

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
      GetDialog.showErrorDialog(title: "Gagal", message: "Gagal mengambil foto");
      return;
    }

    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory profileDir =
      Directory(path.join(appDir.path, 'image', 'barang'));
      if (!await profileDir.exists()) {
        await profileDir.create(recursive: true);
      }

      final fileName =
          'barang_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(999)}.jpg';
      final String newPath = path.join(profileDir.path, fileName);
      await File(image.path).copy(newPath);

      fotoBarang.value = File(newPath);
    } catch (e) {
      GetDialog.showErrorDialog(title: "Error", message: "Gagal menyimpan gambar: $e");
    }
  }

  // =====================================
  // PERHITUNGAN
  // =====================================
  void hitungJarak() {
    try {
      final lat1 = double.parse(latAController.text);
      final lon1 = double.parse(lngAController.text);
      final lat2 = double.parse(latBController.text);
      final lon2 = double.parse(lngBController.text);

      const R = 6371;
      final dLat = _deg2rad(lat2 - lat1);
      final dLon = _deg2rad(lon2 - lon1);
      final a = sin(dLat / 2) * sin(dLat / 2) +
          cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) *
              sin(dLon / 2) * sin(dLon / 2);
      final c = 2 * atan2(sqrt(a), sqrt(1 - a));
      final d = R * c;

      jarakKm.value = d;
    } catch (_) {
      jarakKm.value = 0;
    }
  }

  double _deg2rad(double deg) => deg * pi / 180;

  void formatOngkos(String value) {
    // Izinkan "-" hanya jika berada di depan angka
    final cleaned = value.replaceAll(RegExp(r'[^\d-]'), '');

    // Handle jika minus di tengah atau lebih dari satu
    if (RegExp(r'^-?\d+$').hasMatch(cleaned)) {
      ongkosRaw.value = int.tryParse(cleaned) ?? 0;
    } else {
      ongkosRaw.value = 0;
    }

    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
    ongkosText.value = formatter.format(ongkosRaw.value);
  }

  // =====================================
  // SIMPAN
  // =====================================
  void simpanPengiriman() async {
    try {
      if (fotoBarang.value == null) {
        Get.snackbar("Gagal", "Foto barang wajib diisi",
            backgroundColor: AppColors.cancel);
        return;
      }

      hitungJarak();

      if(ongkosRaw.value.toDouble() < 0){
        Get.snackbar("Gagal", "Harga tidak boleh minus",
            backgroundColor: AppColors.cancel);
        return;
      }

      final delivery = Delivery(
        fotoBarang: fotoBarang.value!.path,
        koordinatAwal: Location(
          lat: double.parse(latAController.text),
          long: double.parse(lngAController.text),
        ),
        koordinatTujuan: Location(
          lat: double.parse(latBController.text),
          long: double.parse(lngBController.text),
        ),
        totalJarak: jarakKm.value,
        totalHarga: ongkosRaw.value.toDouble(),
        userId: GetBox().getIdUser()!,
      );

      await dbHelper.insertDelivery(delivery);


      hc.fetchDeliveries();

      Get.snackbar("Berhasil", "Pengiriman berhasil disimpan",
          backgroundColor: AppColors.second,
          colorText: AppColors.textLight);

      clearForm();
    } catch (e) {
      Get.snackbar("Gagal", "Gagal menyimpan: $e",
          backgroundColor: AppColors.cancel);
    }
  }

  void clearForm() {
    fotoBarang.value = null;
    latAController.clear();
    lngAController.clear();
    latBController.clear();
    lngBController.clear();
    jarakKm.value = 0.0;
    ongkosRaw.value = 0;
    ongkosText.value = '';
    ongkosController.clear();
    ongkosRaw.value = 0;
    ongkosText.value = '';
  }

  @override
  void onClose() {
    latAController.dispose();
    lngAController.dispose();
    latBController.dispose();
    lngBController.dispose();
    ongkosController.dispose();
    super.onClose();
  }
}
