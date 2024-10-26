import 'package:college/utils/constants/sizes.dart';
import 'widgets/login_form.dart';
import 'widgets/login_header.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                // Title & Sub-Title
                LoginHeader(),

                // Form
                LoginForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}