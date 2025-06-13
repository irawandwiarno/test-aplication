import 'package:get/get.dart';
import 'package:test_gojek_app/pages/history/history_binding.dart';
import 'package:test_gojek_app/pages/history/history_view.dart';
import 'package:test_gojek_app/pages/home/home_binding.dart';
import 'package:test_gojek_app/pages/home/home_view.dart';
import 'package:test_gojek_app/pages/login/login_binding.dart';
import 'package:test_gojek_app/pages/login/login_view.dart';
import 'package:test_gojek_app/pages/navigasi/navigasi_view.dart';
import 'package:test_gojek_app/pages/profile/profile_binding.dart';
import 'package:test_gojek_app/pages/profile/profile_view.dart';
import 'package:test_gojek_app/pages/splash/splash_view.dart';
import 'package:test_gojek_app/routes/route_name.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: RouteName.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: RouteName.login,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: RouteName.profile,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: RouteName.navbar,
      page: () => NavigasiView(),
    ),
    GetPage(
      name: RouteName.splash,
      page: () => SplashView(),
    ),
    GetPage(
      name: RouteName.history,
      page: () => HistoryView(),
      binding: HistoryBinding()
    ),
  ];
}
