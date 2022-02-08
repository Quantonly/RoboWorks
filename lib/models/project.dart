import 'package:robo_works/globals/data.dart' as data;

class Project {
  late String id;
  late String name;
  late int robotCount;
  bool hasPermissions = false;

  Project(String i, String n, int r) {
    id = i;
    name = n;
    robotCount = r;
    if (data.grantedProjects.contains(i)) hasPermissions = true;
  }

  static Project fromMap(Map<String, dynamic> map, String projectId) {
    return Project(
      projectId,
      map['name'],
      map['robot_count'],
    );
  }
} 