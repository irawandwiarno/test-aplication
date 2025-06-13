import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_gojek_app/constant/AppColors.dart';
import 'package:test_gojek_app/routes/app_page.dart';
import 'package:test_gojek_app/routes/route_name.dart';
import 'package:test_gojek_app/services/database_helper.dart';
import 'package:test_gojek_app/services/get_box.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
  await GetBox().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gojek App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      getPages: AppPages.pages,
      initialRoute: RouteName.splash,
    );
  }
}

