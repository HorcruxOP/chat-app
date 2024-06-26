import 'package:chat_app/widgets/common/login_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        double minWidth = constraints.maxWidth * 0.5;
        double maxWidth = 500.0;
        double textFieldWidth = minWidth;

        if (textFieldWidth > maxWidth) {
          textFieldWidth = maxWidth;
        }
        return Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  !isLogin ? "Sign Up" : "Log In",
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                !isLogin ? const SizedBox(height: 40) : const SizedBox(),
                !isLogin
                    ? SizedBox(
                        width: textFieldWidth,
                        child: TextFormField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: "Username",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Username cant be empty";
                            }
                            return null;
                          },
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(height: 40),
                SizedBox(
                  width: textFieldWidth,
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email cant be empty";
                      } else if (!(value.contains("@"))) {
                        return "Invalid email";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: textFieldWidth,
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password cant be empty";
                      } else if (value.length <= 6) {
                        return "Password length should atleast of 6 characters";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 30),
                TextButton(
                  child: Text(
                    isLogin
                        ? "Don't have an account?"
                        : "Already have an account?",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                ),
                const SizedBox(height: 20),
                LoginButton(
                  formKey: _formKey,
                  width: textFieldWidth,
                  isLogin: isLogin,
                  emailController: emailController,
                  passwordController: passwordController,
                  usernameController: usernameController,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
