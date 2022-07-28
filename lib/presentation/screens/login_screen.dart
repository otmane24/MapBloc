import 'package:flutter/material.dart';
import 'package:maptest/constants/colors.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  String? phoneNumber;
  Widget _buildIntroTexts() {
    return Column(
      children: [
        const Text(
          'What is your phone number?',
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
          child: const Text(
            'Please entre your phone number to verify your account.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

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
                } else if (value.length < 10) {
                  return 'Too short for a phone number !';
                }
                return null;
              }),
              onSaved: (newValue) {
                phoneNumber = newValue!;
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

  _buildNextButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            minimumSize: Size(110, 50),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: UniqueKey(),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIntroTexts(),
                  const SizedBox(
                    height: 110,
                  ),
                  _buildPhoneFromField(),
                  SizedBox(
                    height: 70,
                  ),
                  _buildNextButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}