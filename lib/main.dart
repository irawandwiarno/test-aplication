import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test_gojek_app/constant/AppColors.dart';
import 'package:test_gojek_app/pages/home/home_binding.dart';
import 'package:test_gojek_app/pages/home/home_view.dart';
import 'package:test_gojek_app/pages/login/login_binding.dart';
import 'package:test_gojek_app/pages/login/login_controller.dart';
import 'package:test_gojek_app/pages/login/login_view.dart';
import 'package:test_gojek_app/pages/profile/profile_binding.dart';
import 'package:test_gojek_app/routes/app_page.dart';
import 'package:test_gojek_app/routes/route_name.dart';
import 'package:test_gojek_app/services/database_helper.dart';
import 'package:test_gojek_app/services/get_box.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
  await GetBox().init();
  bool isFistOpenApp = await GetBox().getFirstOpenApp();
  if(!isFistOpenApp){
    print('to set');
    var resdb = await DatabaseHelper().inserDefaultUser();
    await GetBox().setFirstOpenApp(true);
   bool res = await GetBox().getFirstOpenApp();
    print('set: $res\nres db : $resdb');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      getPages: AppPages.pages,
      initialRoute: RouteName.login,
      initialBinding: LoginBinding(),
    );
  }
}

