import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:robo_works/dialogs/sign_out_dialog.dart';
import 'package:robo_works/glow_behavior.dart';

import 'package:robo_works/models/user_data.dart';
import 'package:robo_works/models/project.dart';
import 'package:robo_works/pages/robots.dart';
import 'package:robo_works/services/database/project_service.dart';
import 'package:robo_works/services/database/user_service.dart';
import 'package:robo_works/globals/data.dart' as data;
import 'package:shared_preferences/shared_preferences.dart';

enum Status { retrieving, retrieved }

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Status status = Status.retrieving;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _fetchUserData();
    });
    super.initState();
  }

  Future<List<Project>> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data.displayName = prefs.getString('displayName') ?? '';
    _refreshPage();
    final firebaseUser = Provider.of<User>(context, listen: false);
    UserData userData = await UserService(uid: firebaseUser.uid).getUserData();
    prefs.setString('displayName', userData.displayName);
    data.displayName = userData.displayName;
    data.grantedProjects = userData.projects;
    List<Project> projects = await _fetchProjects();
    return projects;
  }

  Future<List<Project>> _fetchProjects() async {
    List<Project> projects = await ProjectService().getGrantedProjects();
    data.projects = projects;
    setState(() {
      status = Status.retrieved;
    });
    return projects;
  }

  Future<void> _refreshPage() async {
    setState(() {});
  }

  Widget getInfo(Status newStatus) {
    if (newStatus == Status.retrieving) {
      return const Expanded(
        child: SizedBox(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return Expanded(
        child: SizedBox(
          height: 500,
          child: RefreshIndicator(
            onRefresh: _fetchProjects,
            child: ScrollConfiguration(
              behavior: NoGlowBehavior(),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: data.projects.length,
                itemBuilder: (context, index) {
                  Project project = data.projects[index];
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        child: Column(
                          children: [
                            ListTile(
                              tileColor: const Color.fromRGBO(66, 66, 66, 1),
                              trailing: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Color.fromRGBO(223, 223, 223, 1),
                                ),
                              ),
                              title: Text(
                                project.name,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: Color.fromRGBO(223, 223, 223, 1),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              subtitle: const Text(
                                'Total',
                                style: TextStyle(
                                  color: Color.fromRGBO(223, 223, 223, 0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    }
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
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Text(
                'Welcome, ' + data.displayName,
                style: const TextStyle(
                  color: Color.fromRGBO(223, 223, 223, 1),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: const <Widget>[
                    Text(
                      'Projects',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(223, 223, 223, 1)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          getInfo(status),
        ],
      ),
    );
  }
}
