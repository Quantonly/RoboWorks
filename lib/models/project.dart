class Project {
  late String id;
  late String name;
  late int robotCount;

  Project(String i, String n, int r) {
    id = i;
    name = n;
    robotCount = r;
  }

  static Project fromMap(Map<String, dynamic> map, String projectId) {
    return Project(
      projectId,
      map['name'],
      map['robot_count']
    );
  }
} 