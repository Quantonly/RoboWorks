class UserData {
  late String id;
  late String displayName;
  late List<String> projects;

  UserData(String i, String d, List<String> p) {
    id = i;
    displayName = d;
    projects = p;
  }

  static UserData fromMap(Map<String, dynamic> map, String projectId) {
    List<dynamic> projects = map['projects'];
    return UserData(
      projectId,
      map['displayName'],
      projects.map((p) => p as String).toList()
    );
  }
}