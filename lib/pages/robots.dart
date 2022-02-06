import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:robo_works/models/robot.dart';
import 'package:robo_works/pages/robot_details.dart';
import 'package:robo_works/services/database/robot_service.dart';
import 'package:robo_works/globals/data.dart' as data;

class RobotsPage extends StatefulWidget {
  final String projectId;
  const RobotsPage({Key? key, required this.projectId}) : super(key: key);

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
    List<Robot> robots = await RobotService(projectId: widget.projectId).getRobots();
    data.robots = robots;
    return robots;
  }

  Future<void> _refreshRobots() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 33, 33, 1),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 150,),
          Text(
            widget.projectId,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
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
                  'Go Back',
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
                                  child: RobotDetailsPage(robot: robot),
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
