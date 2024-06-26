// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/pages/home_screen.dart';
import 'package:chat_app/services/functions/auth_functions.dart';
import 'package:chat_app/services/functions/database_functions.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final double width;
  final bool isLogin;
  final TextEditingController emailController,
      passwordController,
      usernameController;
  const LoginButton({
    super.key,
    required this.formKey,
    required this.width,
    required this.isLogin,
    required this.emailController,
    required this.passwordController,
    required this.usernameController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: MaterialButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            if (isLogin) {
              bool success = await signInWithEmailPassword(
                emailController.text,
                passwordController.text,
                context,
              );
              if (success) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              }
            } else {
              bool checkUserNameBool =
                  await checkUserName(usernameController.text, context);
              bool checkEmailBool =
                  await checkEmail(emailController.text, context);
              if (!checkUserNameBool && !checkEmailBool) {
                await createAccountWithEmailPassword(
                  emailController.text,
                  passwordController.text,
                );
                await saveUserDetails(emailController.text,
                    passwordController.text, usernameController.text);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              } else if (checkUserNameBool) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Username already exists")));
              } else if (checkEmailBool) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Email already exists")));
              }
            }
          }
        },
        color: Colors.blue,
        elevation: 5,
        height: 50,
        textColor: Colors.white,
        child: const Text(
          "Submit",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
