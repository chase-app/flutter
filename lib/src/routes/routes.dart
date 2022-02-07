import 'package:chaseapp/src/core/modules/auth/view/pages/auth_view_wrapper.dart';
import 'package:chaseapp/src/core/modules/auth/view/pages/check_permissions.dart';
import 'package:chaseapp/src/core/modules/auth/view/pages/login_register.dart';
import 'package:chaseapp/src/modules/about/view/about.dart';
import 'package:chaseapp/src/modules/chase_view/view/pages/chaseDetails_page.dart';
import 'package:chaseapp/src/modules/credits/view/credits.dart';
import 'package:chaseapp/src/modules/home/view/pages/home_wrapper.dart';
import 'package:chaseapp/src/modules/onboarding/view/pages/check_permissions_status.dart';
import 'package:chaseapp/src/modules/onboarding/view/pages/onboarding.dart';
import 'package:chaseapp/src/modules/profile/view/pages/profile_page.dart';
import 'package:chaseapp/src/modules/splash_screen/view/pages/splash_page.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Map<String, dynamic> arguments = settings.arguments != null
        ? settings.arguments as Map<String, dynamic>
        : Map<String, dynamic>();
    switch (settings.name) {
      case '/':
        return MaterialPageRoute<void>(builder: (context) => const Splash());
      case RouteName.ONBOARDING_VIEW:
        return MaterialPageRoute<void>(builder: (context) => OnBoardingView());
      case RouteName.CHECK_PERMISSIONS_VIEW_WRAPPER:
        return MaterialPageRoute<void>(
            builder: (context) => CheckPermissionsViewWrapper());
      case RouteName.CHECK_PERMISSIONS_VIEW:
        return MaterialPageRoute<void>(
            builder: (context) => CheckPermissionsView());
      case RouteName.AUTH_VIEW_WRAPPER:
        return MaterialPageRoute<void>(builder: (context) => AuthViewWrapper());
      case RouteName.USER_LOGIN:
        return MaterialPageRoute<void>(builder: (_) => LoginOrRegister());
      case RouteName.HOME_WRAPPER:
        return MaterialPageRoute<void>(builder: (_) => HomeWrapper());
      case RouteName.HOME_WRAPPER:
        return MaterialPageRoute<void>(builder: (_) => HomeWrapper());
      case RouteName.CHASE_VIEW:
        final String chaseId = arguments["chaseId"] as String;
        return MaterialPageRoute<void>(
            builder: (_) => ShowChase(
                  chaseId: chaseId,
                ));
      case RouteName.PROFILE:
        return MaterialPageRoute<bool>(builder: (_) => ProfileView());
      case RouteName.CREDITS:
        return MaterialPageRoute<bool>(builder: (_) => CreditsView());
      case RouteName.ABOUT_US:
        return MaterialPageRoute<bool>(builder: (_) => AboutUsView());
      default:
        return MaterialPageRoute<void>(
          builder: (context) => Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
//                  Image.asset('assets/images/error.jpg'),
                  Text(
                    "${settings.name} does not exists!",
                    style: const TextStyle(fontSize: 24.0),
                  )
                ],
              ),
            ),
          ),
        );
    }
  }
}
