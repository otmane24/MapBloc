import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maptest/business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:maptest/presentation/screens/login_screen.dart';

import 'package:flutter/material.dart';
import 'package:maptest/presentation/screens/otp_screen.dart';

import 'constants/string.dart';
import 'presentation/screens/map_screen.dart';

class AppRouter {
  PhoneAuthCubit? phoneAuthCubit;

  AppRouter() {
    phoneAuthCubit = PhoneAuthCubit();
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mapScreen:
        return MaterialPageRoute(builder: (_) => MapScreen());
      case loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: LoginScreen(),
          ),
        );
      case optScreen:
        String phoneNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: OtpScreen(
              phoneNumber: phoneNumber,
            ),
          ),
        );
    }
  }
}
