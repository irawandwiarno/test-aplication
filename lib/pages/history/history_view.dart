import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_gojek_app/constant/AppColors.dart';
import 'package:test_gojek_app/models/delivery_model.dart';
import 'package:test_gojek_app/pages/history/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;

    final double HIGHT = 140;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'History Deliver',
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.textLight),
        ),
      ),
      body: Obx(() {
        if (c.deliveries.isEmpty) {
          return const Center(child: Text("Belum ada pengiriman."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: c.deliveries.length,
          itemBuilder: (context, index) {
            final Delivery d = c.deliveries[index];

            return Card(
              color: AppColors.textLight,
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 12),
              child: Container(
                height: HIGHT,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(d.fotoBarang),
                          width: HIGHT,
                          height: HIGHT,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[300],
                            alignment: Alignment.center,
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text("Pengiriman Barang",
                            //     style: TextStyle(
                            //         fontWeight: FontWeight.bold, fontSize: 17)),
                            Text(
                              "Lokasi:",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppColors.primary,
                                  ),
                                  child: Text(
                                    d.koordinatAwal.lat.toStringAsFixed(6),
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.normal, fontSize: 12, color: AppColors.textLight),
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppColors.primary,
                                  ),
                                  child: Text(
                                    d.koordinatAwal.long.toStringAsFixed(6),
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.normal, fontSize: 12, color: AppColors.textLight),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Tujuan:",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppColors.primary,
                                  ),
                                  child: Text(
                                    d.koordinatTujuan.lat.toStringAsFixed(6),
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.normal, fontSize: 12, color: AppColors.textLight),
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppColors.primary,
                                  ),
                                  child: Text(
                                    d.koordinatTujuan.long.toStringAsFixed(6),
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.normal, fontSize: 12, color: AppColors.textLight),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${d.totalJarak.toStringAsFixed(2)} km",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold),
                                ),
                                Tooltip(
                                  waitDuration: Duration(milliseconds: 100),
                                  message: c.formatOngkos(d.totalHarga.toStringAsFixed(0)),
                                  child: SizedBox(
                                    width: 80,
                                    child: Text(
                                      c.formatOngkos(d.totalHarga.toStringAsFixed(0)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                )

                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () => c.deleteDelivery(d.id!),
                        iconSize: 20,
                        icon: Icon(
                          Icons.delete,
                          color: AppColors.cancel,
                        ))
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
