import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:test_gojek_app/constant/AppColors.dart';
import 'package:test_gojek_app/pages/home/home_controller.dart';
import 'package:test_gojek_app/pages/home/home_view.dart';

class NavigasiView extends StatelessWidget {
  const NavigasiView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PersistentTabConfig> tabs = [
      PersistentTabConfig(
        screen: GetBuilder<HomeController>(
          init: HomeController(),
          builder: (_) => HomeView(),
        ),
        item: ItemConfig(
          icon: Icon(Icons.home_rounded),
          title: 'Beranda',
          activeForegroundColor: AppColors.primary
        ),
      ),
    ];
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
            screen: HomeView(),
            item: ItemConfig(
                icon: Icon(Icons.home_rounded),
                title: 'Beranda'
            )
        ),
        PersistentTabConfig(
            screen: HomeView(),
            item: ItemConfig(
                icon: Icon(Icons.home_rounded),
                title: 'Beranda'
            )
        ),
      ],
      navBarBuilder: (navBarConfig) => Style1BottomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
  }
}
