import 'package:flutter/material.dart';
import 'package:robo_works/models/project.dart';
import 'package:robo_works/services/database/project_service.dart';

class ProjectProvider with ChangeNotifier {
  List<Project> _projects = [];
  List<Project> _filteredProjects = [];
  String currentFilter = "";
  String currentSort = "Name";

  dynamic get projects => _projects;
  dynamic get filteredProjects => _filteredProjects;

  void setProjects() async {
    List<Project> projects = await ProjectService().getGrantedProjects();
    _projects = projects;
    _filteredProjects = projects;
    sortProjects(currentSort);
  }

  void filterProjects(filter) {
    print(filter);
    if (filter == "") {
      _filteredProjects = _projects;
    } else {
      _filteredProjects = _projects
          .where((project) => project.name
              .toLowerCase()
              .contains(filter.toString().toLowerCase()))
          .toList();
    }
    currentFilter = filter;
    sortProjects(currentSort);
  }

  void sortProjects(sort) {
    switch (sort) {
      case "Name": {
        _filteredProjects.sort((a, b) => a.name.compareTo(b.name));
      }
      break;
      case "Total robots": {
        _filteredProjects.sort((a, b) => a.robotCount.compareTo(b.robotCount));
      }
      break;
    }
    currentSort = sort;
    notifyListeners();
  }
}
