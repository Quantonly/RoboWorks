import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:robo_works/models/robot.dart';

class RobotService {
  final String projectId;
  RobotService({required this.projectId});

  final CollectionReference robots =
      FirebaseFirestore.instance.collection('robots');

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
}