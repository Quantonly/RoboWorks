import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:robo_works/models/robot.dart';
import 'package:robo_works/globals/data.dart' as data;

class RobotService {
  final String projectId;
  RobotService({required this.projectId});

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference robots =
      FirebaseFirestore.instance.collection('robots');

  Future<Robot> getRobot(String robotId) async {
    Robot robot = await robots.doc(robotId).get().then((snapshot) {
      return Robot.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
    });
    return robot;
  }

  Future<List<Robot>> getRobots() async {
    List<Robot> response = await robots.where('project', isEqualTo: projectId).get().then((snapshot) {
      List<Robot> robotList = [];
      for (var robot in snapshot.docs) {
        robotList.add(Robot.fromMap(robot.data() as Map<String, dynamic>, robot.id));
      }
      return robotList;
    });
    return response;
  }

  Future<void> setSectionPercentage(Robot robot, String phase, String section, int percentage, int previousPercentage) async {
    await robots.doc(robot.id).update({'phases.' + phase + '.' + section: percentage});
    await analytics.setUserId(id: auth.currentUser?.uid);
    return await analytics.logEvent(
      name: 'set_percentage',
      parameters: <String, dynamic>{
        'display_name': data.displayName,
        'project_id': robot.project,
        'robot_id': robot.id,
        'robot_name': robot.name,
        'percentage': percentage,
        'previous_percentage': previousPercentage
      },
    );
  }
}