class Project {
  late String id;
  late String name;

  Project(String i, String n) {
    id = i;
    name = n;
  }

  static Project fromMap(Map<String, dynamic> map, String projectId) {
    return Project(
      projectId,
      map['name'],
    );
  }
} 