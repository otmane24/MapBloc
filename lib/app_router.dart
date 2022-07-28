import 'package:maptest/presentation/screens/login_screen.dart';

import 'package:flutter/material.dart';

import 'constants/string.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }
}
