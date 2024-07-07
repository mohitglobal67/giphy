import 'package:flutter/material.dart';
import 'package:giphy_app/utils/routes/routes_name.dart';
import 'package:giphy_app/view/favorites/favorites_screen.dart';
import 'package:giphy_app/view/home/home_screen.dart';
import 'package:giphy_app/view/login/login_screen.dart';
import 'package:giphy_app/view/signup/signup_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen());

      case RoutesName.signup:
        return MaterialPageRoute(
            builder: (BuildContext context) => SignupScreen());

      case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen());
      case RoutesName.favorate:
        return MaterialPageRoute(builder: (BuildContext context) => FavoritesScreen());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}
