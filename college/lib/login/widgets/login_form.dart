import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:college/login/login_controller.dart';
import 'package:college/utils/constants/sizes.dart';
import 'package:college/utils/constants/texts.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController authController = Get.put(LoginController());

    return Container(
      alignment: Alignment.center,
      child: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwItems),
          child: SizedBox(
            width: TSizes.buttonWidth * 5,
            child: Column(
              children: [
                // Username
                TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: 'Username',
                  ),
                  controller: authController.usernameController,
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Password
                Obx(
                  ()=> TextField(
                    obscureText: authController.hidePassword.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.password_check),
                      labelText: TTexts.password,
                      suffixIcon: IconButton(
                        onPressed: () => authController.hidePassword.value = !authController.hidePassword.value,
                        icon: Icon(authController.hidePassword.value? Iconsax.eye_slash: Iconsax.eye)
                      )
                    ),
                    controller: authController.passwordController,
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields / 2),
                Obx(() {
                  if (authController.isLoading.value) {
                    return const CircularProgressIndicator();
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: TSizes.spaceBtwInputFields),
                        ElevatedButton(
                          onPressed: () {
                            authController.loginStudent(
                              authController.usernameController.text,
                              authController.passwordController.text,
                            );
                          },
                          child: const Text('Sign In as Student'),
                        ),
                        const SizedBox(height: TSizes.spaceBtwInputFields),
                        ElevatedButton(
                          onPressed: () {
                            authController.loginInstructor(
                              authController.usernameController.text,
                              authController.passwordController.text,
                            );
                          },
                          child: const Text('Sign In as Instructor'),
                        ),
                        const SizedBox(height: TSizes.spaceBtwInputFields),
                        ElevatedButton(
                          onPressed: () {
                            authController.loginAdmin(
                              authController.usernameController.text,
                              authController.passwordController.text,
                            );
                          },
                          child: const Text('Sign In as Admin'),
                        ),
                        Obx(() {
                          if (authController.loginMessage.value.isNotEmpty) {
                            return Text(
                              authController.loginMessage.value,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                      ],
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}