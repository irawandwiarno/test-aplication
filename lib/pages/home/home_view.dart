import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_gojek_app/components/common_button.dart';
import 'package:test_gojek_app/constant/AppColors.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Kirim Barang',
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.textLight),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => GestureDetector(
                  onTap: c.pickFoto,
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                      image: c.fotoBarang.value != null
                          ? DecorationImage(
                              image: FileImage(c.fotoBarang.value!),
                              fit: BoxFit.cover)
                          : null,
                    ),
                    child: c.fotoBarang.value == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                  child: Icon(Icons.camera_alt, size: 40)),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Tambah Gambar'),
                            ],
                          )
                        : null,
                  ),
                )),
            const SizedBox(height: 20),
            Text("Lokasi Driver",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            Row(children: [
              Expanded(child: _buildInput("Latitude", c.latAController)),
              const SizedBox(width: 10),
              Expanded(child: _buildInput("Longitude", c.lngAController)),
            ]),
            const SizedBox(height: 12),
            Text(
              "Lokasi Tujuan",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            Row(children: [
              Expanded(child: _buildInput("Latitude", c.latBController)),
              const SizedBox(width: 10),
              Expanded(child: _buildInput("Longitude", c.lngBController)),
            ]),
            const SizedBox(height: 12),
            Container(
              width: Get.width / 2,
              child: CommonButton(
                onPressed: c.hitungJarak,
                title: "Hitung Jarak",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(() =>
                Text("Jarak Antar: ${c.jarakKm.value.toStringAsFixed(2)} km")),
            const SizedBox(height: 20),
            Text(
              "Ongkos Kirim",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(() => TextFormField(
                  controller: controller.ongkosController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Masukkan ongkos kirim',
                    suffixText: controller.ongkosText.value,
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                  ),
                  onChanged: controller.formatOngkos,
                )),
            const SizedBox(height: 20),
            CommonButton(
              onPressed: c.simpanPengiriman,
              title: "Simpan",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String hint, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hint,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }
}
