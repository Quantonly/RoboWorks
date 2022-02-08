import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:robo_works/services/database/project_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:robo_works/dialogs/sign_out_dialog.dart';
import 'package:robo_works/dialogs/sort_dialog.dart';
import 'package:robo_works/models/user_data.dart';
import 'package:robo_works/models/project.dart';
import 'package:robo_works/pages/robots.dart';
import 'package:robo_works/providers/project_provider.dart';
import 'package:robo_works/services/database/user_service.dart';
import 'package:robo_works/glow_behavior.dart';

import 'package:robo_works/globals/style.dart' as style;
import 'package:robo_works/globals/data.dart' as data;

enum Status { retrieving, retrieved }

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Project> projects = [];
  Status status = Status.retrieving;
  String sort = "Name";
  List<String> dropDown = <String>[
    "Name",
    "Total robots",
  ];

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _fetchUserData();
    });
    super.initState();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data.displayName = prefs.getString('displayName') ?? '';
    _refreshPage();
    final firebaseUser = Provider.of<User>(context, listen: false);
    UserData userData = await UserService(uid: firebaseUser.uid).getUserData();
    prefs.setString('displayName', userData.displayName);
    data.displayName = userData.displayName;
    data.grantedProjects = userData.projects;
    await _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    List<Project> projects = await ProjectService().getProjects();
    context.read<ProjectProvider>().setProjects(projects);
    setState(() {
      status = Status.retrieved;
    });
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
    } else if (projects.isEmpty) {
      return Expanded(
        child: SizedBox(
          child: RefreshIndicator(
            onRefresh: _fetchUserData,
            child: ScrollConfiguration(
              behavior: NoGlowBehavior(),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: const [
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text(
                            'Your account currently has no projects, please contact the administrator.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
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
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  Project project = projects[index];
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
                              subtitle: Text(
                                "Total robots: " +
                                    project.robotCount.toString(),
                                style: const TextStyle(
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
    projects = context.watch<ProjectProvider>().filteredProjects;
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
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, top: 16.0, right: 24),
                  child: TextFormField(
                    initialValue: context.read<ProjectProvider>().currentFilter,
                    decoration: style.getTextFieldDecoration('Search projects'),
                    onChanged: (value) {
                      context.read<ProjectProvider>().filterProjects(value);
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 16.0),
                child: IconButton(
                  color: const Color.fromRGBO(223, 223, 223, 1),
                  icon: const Icon(Icons.sort),
                  tooltip: 'Sort',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => SortDialog(
                        dropDown: dropDown,
                        provider: 'projects',
                      ),
                    );
                  },
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
