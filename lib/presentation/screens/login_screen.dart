import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maptest/business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:maptest/constants/colors.dart';
import 'package:maptest/presentation/widgets/intro_texts.dart';

import '../../constants/string.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  String? phoneNumber;
  final GlobalKey<FormState> _phoneFromKey = GlobalKey<FormState>();

  Widget _buildPhoneFromField() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: MyColors.lightGrey),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '${generateCountryFlag()} +213',
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: MyColors.blue),
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextFormField(
              autofocus: true,
              style: const TextStyle(
                fontSize: 18,
                letterSpacing: 1.5,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              cursorColor: Colors.black,
              keyboardType: TextInputType.phone,
              validator: ((value) {
                if (value!.isEmpty) {
                  return 'Please entre your phone number!';
                } else if (value.length < 9) {
                  return 'Too short for a phone number !';
                }
                return null;
              }),
              onSaved: (newValue) {
                phoneNumber = newValue;
              },
            ),
          ),
        ),
      ],
    );
  }

  String generateCountryFlag() {
    String countryCode = 'dz';
    return countryCode.toUpperCase().replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) =>
              String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
        );
  }

  Future<void> _register(BuildContext context) async {
    if (!_phoneFromKey.currentState!.validate()) {
      Navigator.pop(context);
      return;
    } else {
      Navigator.pop(context);
      _phoneFromKey.currentState!.save();
      BlocProvider.of<PhoneAuthCubit>(context).submitPhoneNumber(phoneNumber!);
    }
  }

  Widget _buildNextButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          showProgresseIndicator(context);
          _register(context);
        },
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(110, 50),
            primary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            )),
        child: const Text(
          'Next',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  showProgresseIndicator(BuildContext context) {
    AlertDialog alertDialog = const AlertDialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ),
    );
    showDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(0),
      barrierDismissible: false,
      builder: ((context) {
        return alertDialog;
      }),
    );
  }

  Widget _buildPhoneNumberSubmitedBlod() {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: ((previous, current) {
        return previous != current;
      }),
      listener: (context, state) {
        if (state is PhoneAuthLoading) {
          showProgresseIndicator(context);
        }
        if (state is PhoneAuthSubmited) {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(optScreen, arguments: phoneNumber);
        }
        if (state is PhoneAuthError) {
          Navigator.of(context).pop();
          String errorMsg = (state).errorMsg;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: Colors.black,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: _phoneFromKey,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextApp().buildIntroTexts('What is your phone number',
                      'Please entre your phone number to verify your account.'),
                  const SizedBox(
                    height: 80,
                  ),
                  _buildPhoneFromField(),
                  const SizedBox(
                    height: 70,
                  ),
                  _buildNextButton(context),
                  _buildPhoneNumberSubmitedBlod(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
