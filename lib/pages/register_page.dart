import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/show_alert.dart';
import '../services/auth_service.dart';
import '../widgets/custom_input.dart';
import '../widgets/login/labels.dart';
import '../widgets/login/logo.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, 'login'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.arrow_back),
                            Text("Volver al inicio"),
                          ],
                        ),
                      ),
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
  final nameController = TextEditingController();
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
            icon: Icons.person_outline,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameController,
          ),
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
                      final isRegisterOk = await authService.signup(
                        nameController.text.trim(),
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );

                      if (isRegisterOk.containsValue(true)) {
                        Navigator.pushReplacementNamed(context, 'users');
                      } else {
                        final List errorList = [];
                        if (isRegisterOk['errors'] != null) {
                          for (var errorKey in isRegisterOk['errors'].keys) {
                            errorList
                                .add(isRegisterOk['errors'][errorKey]['msg']);
                          }
                          showAlert(
                              context, 'Signup failed', errorList.toString());
                        } else {
                          showAlert(context, 'Signup failed',
                              isRegisterOk["msg"].toString());
                        }
                      }
                    },
              child: const Text("Registrarme"))
        ],
      ),
    );
  }
}
