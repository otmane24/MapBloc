import 'package:maptest/presentation/screens/login_screen.dart';

import 'package:flutter/material.dart';
import 'package:maptest/presentation/screens/otp_screen.dart';

import 'constants/string.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case optScreen:
        String _phoneNumber = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => OtpScreen(
                  phoneNumber: _phoneNumber,
                ));
    }
  }
}
