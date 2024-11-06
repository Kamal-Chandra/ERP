import 'package:college/utils/constants/colors.dart';
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
                // Username field
                TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: 'Username',
                  ),
                  controller: authController.usernameController,
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Password field with visibility toggle
                Obx(
                  () => TextField(
                    obscureText: authController.hidePassword.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.password_check),
                      labelText: TTexts.password,
                      suffixIcon: IconButton(
                        onPressed: () => authController.hidePassword.value = !authController.hidePassword.value,
                        icon: Icon(authController.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                      ),
                    ),
                    controller: authController.passwordController,
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Loading indicator or Sign In buttons
                Obx(() {
                  if (authController.isLoading.value) {
                    return const CircularProgressIndicator();
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            authController.loginStudent(
                              authController.usernameController.text,
                              authController.passwordController.text,
                            );
                          },
                          child: const Text('Sign In as Student', style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: TColors.primary)),
                        ),
                        TextButton(
                          onPressed: () {
                            authController.loginInstructor(
                              authController.usernameController.text,
                              authController.passwordController.text,
                            );
                          },
                          child: const Text('Sign In as Faculty', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: TColors.primary)),
                        ),
                        TextButton(
                          onPressed: () {
                            authController.loginAdmin(
                              authController.usernameController.text,
                              authController.passwordController.text,
                            );
                          },
                          child: const Text('Sign In as Admin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: TColors.primary)),
                        ),
                      ],
                    );
                  }
                }),

                // Error message display
                Obx(() {
                  if (authController.loginMessage.value.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: TSizes.spaceBtwInputFields),
                      child: Text(
                        authController.loginMessage.value,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
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