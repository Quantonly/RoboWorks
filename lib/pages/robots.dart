import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:robo_works/dialogs/sign_out_dialog.dart';
import 'package:robo_works/models/project.dart';
import 'package:robo_works/models/robot.dart';
import 'package:robo_works/pages/robot_details.dart';
import 'package:robo_works/services/database/robot_service.dart';
import 'package:robo_works/globals/data.dart' as data;

class RobotsPage extends StatefulWidget {
  final Project project;
  const RobotsPage({Key? key, required this.project}) : super(key: key);

  @override
  State<RobotsPage> createState() => _RobotsPageState();
}

class _RobotsPageState extends State<RobotsPage> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _fetchRobots();
    });
    super.initState();
  }

  Future<List<Robot>> _fetchRobots() async {
    List<Robot> robots = await RobotService(projectId: widget.project.id).getRobots();
    data.robots = robots;
    return robots;
  }

  Future<void> _refreshRobots() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
        title: const Text(
          'Project',
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
                future: _fetchRobots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return RefreshIndicator(
                      onRefresh: _refreshRobots,
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          Robot robot = snapshot.data[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: RobotDetailsPage(project: widget.project, robot: robot),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  robot.name,
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
