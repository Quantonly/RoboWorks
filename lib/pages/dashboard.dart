import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:robo_works/models/user_data.dart';
import 'package:robo_works/models/project.dart';
import 'package:robo_works/pages/robots.dart';
import 'package:robo_works/services/authentication.dart';
import 'package:robo_works/services/database/project_service.dart';
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
      _fetchUserData();
    });
    super.initState();
  }

  Future<List<Project>> _fetchUserData() async {
    final firebaseUser = Provider.of<User>(context, listen: false);
    UserData userData = await UserService(uid: firebaseUser.uid).getUserData();
    data.displayName = userData.displayName;
    data.grantedProjects = userData.projects;
    List<Project> projects = await _fetchProjects();
    return projects;
  }

  Future<List<Project>> _fetchProjects() async {
    List<Project> projects = await ProjectService().getGrantedProjects();
    data.projects = projects;
    return projects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 33, 33, 1),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 150,
          ),
          const Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
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
          Expanded(
            child: SizedBox(
              height: 500,
              child: FutureBuilder(
                future: _fetchUserData(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        Project project = snapshot.data[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: RobotsPage(projectId: project.id),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                project.name,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 28),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
