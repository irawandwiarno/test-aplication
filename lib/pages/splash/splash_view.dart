import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_gojek_app/routes/route_name.dart';
import 'package:test_gojek_app/services/get_box.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {

    // Tunggu sebentar lalu redirect
    Future.delayed(Duration(milliseconds: 300), () {
      int? isLoggedIn = GetBox().getIdUser();
      if (isLoggedIn != null) {
        Get.offAllNamed(RouteName.navbar);
      } else {
        Get.offAllNamed(RouteName.login);
      }
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
