import 'dart:convert';

class Location {
  double long;
  double lat;

  Location({required this.long, required this.lat});

  Map<String, dynamic> toJson() => {
    'long': long,
    'lat': lat,
  };

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      long: (json['long'] as num).toDouble(),
      lat: (json['lat'] as num).toDouble(),
    );
  }
}


class Delivery {
  int? id;
  String fotoBarang;
  Location koordinatAwal;
  Location koordinatTujuan;
  double totalJarak;
  double totalHarga;
  String createdAt;
  int userId;

  Delivery({
    this.id,
    required this.fotoBarang,
    required this.koordinatAwal,
    required this.koordinatTujuan,
    required this.totalJarak,
    required this.totalHarga,
    required this.userId,
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foto_barang': fotoBarang,
      'koordinat_awal': jsonEncode(koordinatAwal.toJson()),
      'koordinat_tujuan': jsonEncode(koordinatTujuan.toJson()),
      'total_jarak': totalJarak,
      'total_harga': totalHarga,
      'created_at': createdAt,
      'user_id': userId,
    };
  }

  factory Delivery.fromMap(Map<String, dynamic> map) {
    return Delivery(
      id: map['id'],
      fotoBarang: map['foto_barang'],
      koordinatAwal: Location.fromJson(jsonDecode(map['koordinat_awal'])),
      koordinatTujuan: Location.fromJson(jsonDecode(map['koordinat_tujuan'])),
      totalJarak: (map['total_jarak'] as num).toDouble(),
      totalHarga: (map['total_harga'] as num).toDouble(),
      createdAt: map['created_at'],
      userId: map['user_id'],
    );
  }
}
