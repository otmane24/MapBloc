// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maptest/constants/colors.dart';
import 'package:maptest/constants/string.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../business_logic/cubit/phone_auth/phone_auth_cubit.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);
  final phoneNumber;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late String optCode;
  Widget _buildIntroTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verify your phone number',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: RichText(
            text: TextSpan(
                text: 'Enter your 6 digit code number sent to ',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                      text: '${widget.phoneNumber}',
                      style: const TextStyle(color: MyColors.blue))
                ]),
          ),
        )
      ],
    );
  }

  Widget _buildPinCodeFields(BuildContext context) {
    return Container(
      child: PinCodeTextField(
        appContext: context,
        autoFocus: true,
        cursorColor: Colors.black,
        keyboardType: TextInputType.number,
        length: 6,
        obscureText: false,
        animationType: AnimationType.scale,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(6),
          fieldHeight: 50,
          fieldWidth: 40,
          activeColor: MyColors.blue,
          inactiveColor: MyColors.lightblue,
          inactiveFillColor: Colors.white,
          activeFillColor: Colors.white,
          selectedColor: MyColors.blue,
          selectedFillColor: Colors.white,
          borderWidth: 1,
        ),
        textStyle: TextStyle(fontSize: 20),
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Colors.white,
        enableActiveFill: true,
        onCompleted: (submitedCode) {
          optCode = submitedCode;
          print("Completed");
        },
        onChanged: (value) {
          print(value);
        },
        beforeTextPaste: (text) {
          print("Allowing to paste $text");
          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
          //but you can show anything you want here, like your pop up saying wrong paste format or etc
          return true;
        },
      ),
    );
  }

  void _login(BuildContext context) {
    BlocProvider.of<PhoneAuthCubit>(context).submiteOTP(this.optCode);
  }

  _buildNextButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          showProgresseIndicator(context);
          _login(context);
        },
        style: ElevatedButton.styleFrom(
            minimumSize: Size(110, 50),
            primary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            )),
        child: const Text(
          'Valide',
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
      elevation: 1,
      backgroundColor: Colors.transparent,
      content: Center(
        child: CircularProgressIndicator.adaptive(
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
        if (state is PhoneOPTVerified) {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(mapScreen);
        }
        if (state is PhoneAuthError) {
          // Navigator.of(context).pop();
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
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
            child: Column(
              children: [
                _buildIntroTexts(),
                const SizedBox(
                  height: 80,
                ),
                _buildPinCodeFields(context),
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
    );
  }
}
