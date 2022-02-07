import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:robo_works/dialogs/sign_out_dialog.dart';
import 'package:robo_works/glow_behavior.dart';
import 'package:robo_works/models/project.dart';
import 'package:robo_works/models/robot.dart';
import 'package:robo_works/pages/robot_details.dart';
import 'package:robo_works/services/database/robot_service.dart';
import 'package:robo_works/globals/data.dart' as data;
import 'package:robo_works/globals/phases.dart' as phases;

enum Status { retrieving, retrieved }

class RobotsPage extends StatefulWidget {
  final Project project;
  const RobotsPage({Key? key, required this.project}) : super(key: key);

  @override
  State<RobotsPage> createState() => _RobotsPageState();
}

class _RobotsPageState extends State<RobotsPage> {
  Status status = Status.retrieving;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _fetchRobots();
    });
    super.initState();
  }

  Future<List<Robot>> _fetchRobots() async {
    List<Robot> robots =
        await RobotService(projectId: widget.project.id).getRobots();
    data.robots = robots;
    setState(() {
      status = Status.retrieved;
    });
    return robots;
  }

  Future<void> _refreshRobots() async {
    setState(() {});
  }

  int getRobotPercentage(Robot robot) {
    int total = 0;
    int totalValues = 0;
    phases.sections.forEach((key, value) {
      List<int> values = [];
      List<String> phaseValues = value as List<String>;
      for (var section in phaseValues) {
        values.add(robot.phases[key][section] ?? 0);
        totalValues++;
      }
      total += (values.reduce((a, b) => a + b).toDouble()).round();
    });
    return (total / totalValues).round();
  }

  String getCurrentPhase(Robot robot) {
    String currentPhase = '';
    phases.sections.forEach((key, value) {
      List<int> values = [];
      List<String> phaseValues = value as List<String>;
      for (var section in phaseValues) {
        values.add(robot.phases[key][section] ?? 0);
      }
      int percentage =
          (values.reduce((a, b) => a + b).toDouble() / values.length).round();
      if (percentage < 100 && currentPhase == '') currentPhase = key;
    });
    switch (currentPhase) {
      case 'phase_1':
        currentPhase = 'Phase 1: Setup & Commissioning';
        break;
      case 'phase_2':
        currentPhase = 'Phase 2: Safety';
        break;
      case 'phase_3':
        currentPhase = 'Phase 3: Path Verification';
        break;
      case 'phase_4':
        currentPhase = 'Phase 4: Automatic Build';
        break;
      case 'phase_5':
        currentPhase = 'Phase 5: Documentation';
        break;
      case '':
        currentPhase = 'All phases complete';
        break;
    }
    return currentPhase;
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
            onRefresh: _fetchRobots,
            child: ScrollConfiguration(
              behavior: NoGlowBehavior(),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: data.robots.length,
                itemBuilder: (context, index) {
                  Robot robot = data.robots[index];
                  int percentage = getRobotPercentage(robot);
                  String currentPhase = getCurrentPhase(robot);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: RobotDetailsPage(
                              project: widget.project, robot: robot),
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
                              leading: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  percentage.toString() + "%",
                                  style: const TextStyle(
                                    color: Color.fromRGBO(223, 223, 223, 1),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              title: Text(
                                robot.name,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: Color.fromRGBO(223, 223, 223, 1),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              subtitle: Text(
                                currentPhase,
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
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Text(
                'Project name: ' + widget.project.name,
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
                      'Robots',
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
