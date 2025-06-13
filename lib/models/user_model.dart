class User {
  int? id;
  String? fotoDriver;
  String? namaDriver;
  String? noKtp;
  String password;
  String email;

  User({
    this.id,
    this.fotoDriver,
    this.namaDriver = '',
    this.noKtp = '',
    required this.password,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foto_driver': fotoDriver,
      'nama_driver': namaDriver,
      'no_ktp': noKtp,
      'password': password,
      'email': email.toLowerCase(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fotoDriver: map['foto_driver'],
      namaDriver: map['nama_driver'],
      noKtp: map['no_ktp'],
      password: map['password'],
      email: map['email'],
    );
  }
}
