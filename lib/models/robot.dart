class Robot {
  late String id;
  late String name;
  late String project;
  late Map<String, dynamic> phases;

  Robot(String i, String n, String p, Map<String, dynamic> ph) {
    id = i;
    name = n;
    project = p;
    phases = ph;
  }

  static Robot fromMap(Map<String, dynamic> map, String projectId) {
    return Robot(
      projectId,
      map['name'],
      map['project'],
      map['phases'],
    );
  }
} 