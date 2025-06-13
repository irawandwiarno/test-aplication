import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:test_gojek_app/constant/AppColors.dart';
import 'package:test_gojek_app/pages/history/history_controller.dart';
import 'package:test_gojek_app/pages/history/history_view.dart';
import 'package:test_gojek_app/pages/home/home_controller.dart';
import 'package:test_gojek_app/pages/home/home_view.dart';
import 'package:test_gojek_app/pages/profile/profile_controller.dart';
import 'package:test_gojek_app/pages/profile/profile_view.dart';

class NavigasiView extends StatelessWidget {
   NavigasiView({super.key});

   final historyCon = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    final List<PersistentTabConfig> tabs = [
      // BERANDA
      PersistentTabConfig(
        screen: GetBuilder<HomeController>(
          init: HomeController(),
          builder: (_) => const HomeView(),
        ),
        item: ItemConfig(
          icon: const Icon(Icons.home_rounded),
          title: 'Beranda',
          activeForegroundColor: AppColors.primary,
        ),
      ),

      // HISTORY
      PersistentTabConfig(
        screen: GetBuilder<HistoryController>(
          init: HistoryController(),
          builder: (_) => const HistoryView(),
        ),
        item: ItemConfig(
          icon: const Icon(Icons.history),
          title: 'Riwayat',
          activeForegroundColor: AppColors.primary,
        ),
      ),

      // PROFILE
      PersistentTabConfig(
        screen: GetBuilder<ProfileController>(
          init: ProfileController(),
          builder: (_) => const ProfileView(),
        ),
        item: ItemConfig(
          icon: const Icon(Icons.person_rounded),
          title: 'Profil',
          activeForegroundColor: AppColors.primary,
        ),
      ),
    ];

    return PersistentTabView(
      tabs: tabs,
      navBarBuilder: (navBarConfig) => Style4BottomNavBar(
        navBarDecoration:
            NavBarDecoration(

            ),
        navBarConfig: navBarConfig,
      ),
    );
  }
}
