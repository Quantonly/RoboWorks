import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:page_transition/page_transition.dart';

import 'package:provider/provider.dart';
import 'package:robo_works/pages/authentication/forgot_password.dart';

import 'package:robo_works/services/authentication.dart';
import 'package:robo_works/globals/style.dart' as style;

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login(String method) async {
    context
        .read<AuthenticationService>()
        .signIn(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        )
        .then(
          (res) => {
            if (res['error'] != null)
              {
                showErrorToast(res['error']),
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

  void showSuccessToast(text) {
    MotionToast.success(
      title: const Text(
        'Success',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(text),
      animationType: ANIMATION.fromTop,
      position: MOTION_TOAST_POSITION.top,
      width: 300,
      toastDuration: const Duration(milliseconds: 4000),
    ).show(context);
    FocusScope.of(context).unfocus();
  }

  void passwordReset() async {
    final result = await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: const ForgotPasswordPage(),
      ),
    );
    if (result != null) {
      emailController.text = result;
      passwordController.clear();
      showSuccessToast('Password reset mail has been send');
    }
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
                    'Sign In',
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
                child: Column(children: <Widget>[
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: style.getTextFieldDecoration('Password'),
                      validator:
                          RequiredValidator(errorText: 'Password is required'),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      obscureText: true,
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 10,
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      passwordReset();
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Colors.blueAccent,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    login('signin');
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
                      'Sign In',
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
