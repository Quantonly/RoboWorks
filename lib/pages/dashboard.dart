import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:robo_works/dialogs/sign_out_dialog.dart';

import 'package:robo_works/models/user_data.dart';
import 'package:robo_works/models/project.dart';
import 'package:robo_works/pages/robots.dart';
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

  Future<void> _refreshProjects() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
        title: const Text(
          'Dashboard',
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => const SignOutDialog(),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(33, 33, 33, 1),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: 500,
              child: FutureBuilder(
                future: _fetchUserData(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return RefreshIndicator(
                      onRefresh: _refreshProjects,
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          Project project = snapshot.data[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: RobotsPage(project: project),
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
                      ),
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
