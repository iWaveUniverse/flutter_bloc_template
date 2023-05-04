import 'package:get/get.dart';
import '../presentation/presentation.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: Routes.init,
      page: () => SplashScreen(),
    ),
    GetPage(
        name: Routes.nav,
        page: () => NavigationScreen(),
        binding: BindingsBuilder.put(() => NavigationBloc())),
  ];
}

abstract class Routes {
  static const init = '/';
  static const login = '/login';
  static const nav = '/nav';
}
