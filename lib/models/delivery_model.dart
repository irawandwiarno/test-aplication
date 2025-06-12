import 'dart:convert';

class Delivery {
  int? id;
  String fotoBarang;
  Map<String, dynamic> koordinatAwal;
  Map<String, dynamic> koordinatTujuan;
  double totalJarak;
  double totalHarga;
  String createdAt;

  Delivery({
    this.id,
    required this.fotoBarang,
    required this.koordinatAwal,
    required this.koordinatTujuan,
    required this.totalJarak,
    required this.totalHarga,
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foto_barang': fotoBarang,
      'koordinat_awal': jsonEncode(koordinatAwal),
      'koordinat_tujuan': jsonEncode(koordinatTujuan),
      'total_jarak': totalJarak,
      'total_harga': totalHarga,
      'created_at': createdAt,
    };
  }

  factory Delivery.fromMap(Map<String, dynamic> map) {
    return Delivery(
      id: map['id'],
      fotoBarang: map['foto_barang'],
      koordinatAwal: jsonDecode(map['koordinat_awal']),
      koordinatTujuan: jsonDecode(map['koordinat_tujuan']),
      totalJarak: map['total_jarak'],
      totalHarga: map['total_harga'],
      createdAt: map['created_at'],
    );
  }
}
