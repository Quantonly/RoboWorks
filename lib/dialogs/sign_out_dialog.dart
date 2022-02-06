import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robo_works/services/authentication.dart';

class SignOutDialog extends StatelessWidget {
  const SignOutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(20),
      title: const Text('Sign out'),
      content: const SizedBox(
        width: double.maxFinite,
        child: Text('Are you sure you want to sign out?'),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            context.read<AuthenticationService>().signOut();
          },
        ),
      ],
    );
  }
}
