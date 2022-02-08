import 'package:flutter/material.dart';
import 'package:robo_works/models/robot.dart';
import 'package:robo_works/services/database/robot_service.dart';

class RobotProvider with ChangeNotifier {
  List<Robot> _robots = [];
  List<Robot> _filteredRobots = [];
  String currentFilter = "";
  String currentSort = "Name";

  dynamic get robots => _robots;
  dynamic get filteredRobots => _filteredRobots;

  void setRobots(String projectId) async {
    List<Robot> robots = await RobotService(projectId: projectId).getRobots();
    _robots = robots;
    _filteredRobots = robots;
    sortRobots(currentSort);
  }

  void filterRobots(filter) {
    if (filter == "") {
      _filteredRobots = _robots;
    } else {
      _filteredRobots = _robots
          .where((robot) => robot.name
              .toLowerCase()
              .contains(filter.toString().toLowerCase()))
          .toList();
    }
    currentFilter = filter;
    sortRobots(currentSort);
  }

  void sortRobots(sort) {
    switch (sort) {
      case "Name": {
        _filteredRobots.sort((a, b) => a.name.compareTo(b.name));
      }
      break;
      case "Percentage": {
        _filteredRobots.sort((a, b) => a.percentage.compareTo(b.percentage));
      }
      break;
    }
    currentSort = sort;
    notifyListeners();
  }
}
