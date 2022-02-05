import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:robo_works/models/user_data.dart';
import 'package:robo_works/services/authentication.dart';
import 'package:robo_works/services/database/user_service.dart';
import 'package:robo_works/globals/data.dart' as data;

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getUserData();
    });
    super.initState();
  }

  getUserData() async {
    final firebaseUser = Provider.of<User>(context, listen: false);
    UserData userData = await UserService(uid: firebaseUser.uid).getUserData();
    data.displayName = userData.displayName;
    data.projects = userData.projects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.black87,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Dashboard'),
            GestureDetector(
              onTap: () {
                context.read<AuthenticationService>().signOut();
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
                    'Sign Out',
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
    );
  }
}
