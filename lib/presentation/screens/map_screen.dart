import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maptest/business_logic/cubit/phone_auth/phone_auth_cubit.dart';

import '../../constants/string.dart';

class MapScreen extends StatelessWidget {
  MapScreen({Key? key}) : super(key: key);
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider<PhoneAuthCubit>(
        create: (context) => phoneAuthCubit,
        child: ElevatedButton(
          onPressed: () async {
            await phoneAuthCubit.logOut();
            Navigator.pushReplacementNamed(context, loginScreen);
          },
          style: ElevatedButton.styleFrom(
              minimumSize: Size(110, 50),
              primary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              )),
          child: const Text(
            'Log out',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
