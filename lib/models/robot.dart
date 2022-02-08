import 'package:robo_works/globals/phases.dart' as phases_data;
import 'package:robo_works/globals/data.dart' as data;

class Robot {
  late String id;
  late String name;
  late String project;
  late Map<String, dynamic> phases;
  int percentage = 0;
  bool hasPermissions = false;

  Robot(String i, String n, String p, Map<String, dynamic> ph) {
    id = i;
    name = n;
    project = p;
    phases = ph;
    calculateRobotPercentage();
    if (data.grantedProjects.contains(p)) hasPermissions = true;
  }

  int getSectionPercentage(String phase, int index) {
    return phases[phase][phases_data.sections[phase][index]] ?? 0;
  }

  int calculatePhasePercentage(String phase) {
    Map<String, dynamic> convertedPhase = phases[phase] as Map<String, dynamic>;
    List<int> values = [];
    convertedPhase.forEach((key, value) {
      values.add(value);
    });
    if (values.isNotEmpty) return (values.reduce((a, b) => a + b).toDouble() / phases_data.sections[phase].length).round();
    return 0;
    
  }

  void calculateRobotPercentage() {
    int total = 0;
    int totalValues = 0;
    phases_data.sections.forEach((key, value) {
      List<int> values = [];
      List<String> phaseValues = value as List<String>;
      for (var section in phaseValues) {
        values.add(phases[key][section] ?? 0);
        totalValues++;
      }
      total += (values.reduce((a, b) => a + b).toDouble()).round();
    });
    percentage = (total / totalValues).round();
  }

  String getCurrentPhase() {
    String currentPhase = '';
    phases_data.sections.forEach((key, value) {
      List<int> values = [];
      List<String> phaseValues = value as List<String>;
      for (var section in phaseValues) {
        values.add(phases[key][section] ?? 0);
      }
      int percentage =
          (values.reduce((a, b) => a + b).toDouble() / values.length).round();
      if (percentage < 100 && currentPhase == '') currentPhase = key;
    });
    switch (currentPhase) {
      case 'phase_1':
        currentPhase = 'Phase 1: Setup & Commissioning';
        break;
      case 'phase_2':
        currentPhase = 'Phase 2: Safety';
        break;
      case 'phase_3':
        currentPhase = 'Phase 3: Path Verification';
        break;
      case 'phase_4':
        currentPhase = 'Phase 4: Automatic Build';
        break;
      case 'phase_5':
        currentPhase = 'Phase 5: Documentation';
        break;
      case '':
        currentPhase = 'All phases complete';
        break;
    }
    return currentPhase;
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