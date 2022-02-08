import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

import 'package:provider/provider.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:robo_works/services/authentication.dart';

import 'package:robo_works/globals/style.dart' as style;

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  void resetPassword() async {
    context
        .read<AuthenticationService>()
        .forgotPassword(
          email: emailController.text.trim(),
        )
        .then(
          (res) => {
            if (res['error'] != null)
              {
                showErrorToast(res['error']),
              },
            if (res['success'] != null)
              {
                Navigator.pop(context, emailController.text.trim()),
              },
          },
        );
  }

  void showErrorToast(text) {
    MotionToast.error(
      title: const Text(
        'Error',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(text),
      animationType: ANIMATION.fromTop,
      position: MOTION_TOAST_POSITION.top,
      width: 300,
      toastDuration: const Duration(milliseconds: 2000),
    ).show(context);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
        title: const Text(
          'RoboWorks',
        ),
      ),
      backgroundColor: const Color.fromRGBO(33, 33, 33, 1),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                child: const Center(
                  child: Text(
                    'Forgot password',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: TextFormField(
                        controller: emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: style.getTextFieldDecoration('Email'),
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Invalid email'),
                          EmailValidator(errorText: 'Invalid email'),
                        ]),
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    resetPassword();
                  }
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Text(
                      'Reset password',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
