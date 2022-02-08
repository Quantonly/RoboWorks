import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:robo_works/dialogs/sign_out_dialog.dart';
import 'package:robo_works/dialogs/sort_dialog.dart';
import 'package:robo_works/glow_behavior.dart';
import 'package:robo_works/models/project.dart';
import 'package:robo_works/models/robot.dart';
import 'package:robo_works/pages/robot_details.dart';
import 'package:robo_works/providers/robot_provider.dart';
import 'package:robo_works/globals/style.dart' as style;
import 'package:robo_works/services/database/robot_service.dart';

enum Status { retrieving, retrieved }

class RobotsPage extends StatefulWidget {
  final Project project;
  const RobotsPage({Key? key, required this.project}) : super(key: key);

  @override
  State<RobotsPage> createState() => _RobotsPageState();
}

class _RobotsPageState extends State<RobotsPage> {
  List<Robot> robots = [];
  Status status = Status.retrieving;
  String sort = "Name";
  int totalCompleted = 0;
  List<String> dropDown = <String>[
    "Name",
    "Percentage",
  ];

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _fetchRobots();
    });
    super.initState();
  }

  Future<void> _fetchRobots() async {
    List<Robot> robots = await RobotService(projectId: widget.project.id).getRobots();
    context.read<RobotProvider>().setRobots(widget.project.id, robots);
    setState(() {
      status = Status.retrieved;
    });
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
    } else if (robots.isEmpty) {
      return Expanded(
        child: SizedBox(
          child: RefreshIndicator(
            onRefresh: _fetchRobots,
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
                            'There are currently no robots for this project, please contact the administrator.',
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
            onRefresh: _fetchRobots,
            child: ScrollConfiguration(
              behavior: NoGlowBehavior(),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: robots.length,
                itemBuilder: (context, index) {
                  Robot robot = robots[index];
                  int percentage = robot.percentage;
                  String currentPhase = robot.getCurrentPhase();
                  Color titleColor = const Color.fromRGBO(223, 223, 223, 1);
                  Color subtitleColor =
                      const Color.fromRGBO(223, 223, 223, 0.7);
                  if (percentage == 100) {
                    titleColor = const Color.fromRGBO(102, 187, 106, 1);
                    subtitleColor = const Color.fromRGBO(102, 187, 106, 0.7);
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: RobotDetailsPage(
                              project: widget.project, robot: robot),
                        ),
                      ).then(
                        (value) =>
                            context.read<RobotProvider>().sortRobots(sort),
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
                                  style: TextStyle(
                                    color: titleColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              title: Text(
                                robot.name,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: titleColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              subtitle: Text(
                                currentPhase,
                                style: TextStyle(
                                  color: subtitleColor,
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

  void countCompleted() {
    totalCompleted = 0;
    for (var robot in robots) {
      if (robot.percentage == 100) totalCompleted++;
    }
  }

  @override
  Widget build(BuildContext context) {
    robots = context.watch<RobotProvider>().filteredRobots;
    countCompleted();
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Robots',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(223, 223, 223, 1)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  "Completed: " +
                      totalCompleted.toString() +
                      "/" +
                      robots.length.toString(),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(223, 223, 223, 1)),
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
                    initialValue: context.read<RobotProvider>().currentFilter,
                    decoration: style.getTextFieldDecoration('Search robots'),
                    onChanged: (value) {
                      context.read<RobotProvider>().filterRobots(value);
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
                        provider: 'robots',
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
