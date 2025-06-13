import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_gojek_app/components/show_error_dialog.dart';
import 'package:test_gojek_app/constant/AppColors.dart';
import 'package:test_gojek_app/models/delivery_model.dart';
import 'package:test_gojek_app/routes/route_name.dart';
import 'package:test_gojek_app/services/database_helper.dart';
import 'package:test_gojek_app/services/get_box.dart';

class HistoryController extends GetxController {
  var deliveries = <Delivery>[].obs;

  final DatabaseHelper db = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchDeliveries();
  }

  void refresh(){
    deliveries.clear();
    fetchDeliveries();
  }

  void fetchDeliveries() async {
    try {
      final userId = GetBox().getIdUser()!;
      deliveries.value = await db.getDeliveriesByUser(userId);
    } catch (e) {
      Get.offAllNamed(RouteName.login);
    }
  }

  void deleteDelivery(int id) async {
    final bool confirmed = await _showLogoutConfirmationDialog();
    if (!confirmed) return;

    try {
      final result = await db.deleteDelivery(id);
      if (result > 0) {
        deliveries.removeWhere((d) => d.id == id);
        Get.snackbar("Berhasil", "Pengiriman berhasil dihapus", backgroundColor: AppColors.second, colorText: AppColors.textLight);
      } else {
        Get.snackbar("Gagal", "Tidak ada data yang dihapus", backgroundColor: AppColors.cancel);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus pengiriman: $e", backgroundColor: AppColors.cancel);
    }
  }

  Future<bool> _showLogoutConfirmationDialog() async {
    bool? confirmed = await GetDialog.showConfirmationDialog(
        title: 'Konfirmasi Hapus',
        message: 'Apakah Anda yakin ingin Menghapus data ini?',
        confirmText: 'Ya',
        cancelText: 'Batal',
        icon: Icons.delete_forever_outlined
    );
    return confirmed ?? false;
  }


  String formatOngkos(String value) {
    int ongkosRaw = 0;
    value = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (value.isEmpty) value = '0';
    ongkosRaw = int.parse(value);
    final formatter =
    NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(ongkosRaw);
  }
}
