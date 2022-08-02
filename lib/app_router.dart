import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maptest/business_logic/cubit/google_map/google_map_cubit.dart';
import 'package:maptest/data/repository/placeSuggestionRepository.dart';
import 'package:maptest/data/webservices/placeSuggestionWebService.dart';
import 'business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'presentation/screens/login_screen.dart';

import 'package:flutter/material.dart';
import 'presentation/screens/otp_screen.dart';

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
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => GoogleMapCubit(
                      PlaceSuggestionRepository(PlaceWebService())),
                  child: MapScreen(),
                ));
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
