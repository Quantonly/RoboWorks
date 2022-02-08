import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:robo_works/models/project.dart';

class ProjectService {
  ProjectService();

  final CollectionReference projects =
      FirebaseFirestore.instance.collection('projects');

  Future<List<Project>> getProjects() async {
    List<Project> response = await projects.get().then((snapshot) {
      List<Project> projectList = [];
      for (var project in snapshot.docs) {
        projectList.add(Project.fromMap(project.data() as Map<String, dynamic>, project.id));
      }
      return projectList;
    });
    return response;
  }
}
