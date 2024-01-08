import 'package:chat_app/helpers/show_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../widgets/custom_input.dart';
import '../widgets/login/labels.dart';
import '../widgets/login/logo.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xffF2F2F2),
          body: Center(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Logo(),
                      _Form(),
                      const Labels(),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 36),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailController,
          ),
          CustomInput(
            icon: Icons.lock_outline_rounded,
            placeholder: 'Contraseña',
            textController: passwordController,
            isPassword: true,
          ),
          ElevatedButton(
              onPressed: authService.isAuthenticating
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();

                      final String email = emailController.text.trim();
                      final String password = passwordController.text.trim();

                      final isLoginOK =
                          await authService.login(email, password);
                      if (isLoginOK) {
                        // Nav
                      } else {
                        showAlert(context, 'Login failed', 'Wrong credentials');
                      }
                    },
              child: const Text("Iniciar sesión"))
        ],
      ),
    );
  }
}
