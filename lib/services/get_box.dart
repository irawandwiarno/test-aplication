import 'package:get_storage/get_storage.dart';

class GetBox {
  static final GetBox _instance = GetBox._internal();
  late final GetStorage _box;

  static const String _firstOpenAppKey = 'first_open_app';
  static const String _idUser = 'id_user';

  factory GetBox() {
    return _instance;
  }

  GetBox._internal() {
    _box = GetStorage();
  }

  /// Inisialisasi GetStorage
  Future<void> init() async {
    await GetStorage.init();
  }

  /// Set first open app
  Future<void> setFirstOpenApp(bool value) async {
    await _box.write(_firstOpenAppKey, value);
  }

  /// Get first open app
  bool getFirstOpenApp() {
    return _box.read(_firstOpenAppKey) ?? true;
  }

  ///Set login Id User
  Future<void> setIdUser(int value)async{
    await _box.write(_idUser, value);
  }

  ///Get Login Id if notfound return -1
  int? getIdUser() {
    return _box.read(_idUser) ?? null;
  }

  Future<bool> deleteIdUser()async{
    try{
    _box.remove(_idUser);
    }catch(e){
      return false;
    }
    return true;
  }

  /// Optional: Clear storage
  Future<void> clear() async {
    await _box.erase();
  }
}