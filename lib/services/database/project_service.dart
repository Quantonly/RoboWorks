import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:robo_works/models/project.dart';
import 'package:robo_works/globals/data.dart' as data;

class ProjectService {
  ProjectService();

  final CollectionReference projects =
      FirebaseFirestore.instance.collection('projects');

  Future<List<Project>> getGrantedProjects() async {
    List<Project> projectList = [];
    if (data.grantedProjects.isNotEmpty) {
      await Future.forEach(data.grantedProjects, (String projectId) async {
        Project response = await projects.doc(projectId).get().then((snapshot) {
          Project project = Project.fromMap(
              snapshot.data() as Map<String, dynamic>, projectId);
          return project;
        });
        projectList.add(response);
      });
    }
    return projectList;
  }
}
