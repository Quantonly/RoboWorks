import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:robo_works/providers/project_provider.dart';
import 'package:robo_works/providers/robot_provider.dart';

class SortDialog extends StatefulWidget {
  final List<String> dropDown;
  final String provider;
  const SortDialog({Key? key, required this.dropDown, required this.provider}) : super(key: key);

  @override
  State<SortDialog> createState() => _SortDialogState();
}

class _SortDialogState extends State<SortDialog> {

  Widget getDropDown() {
    List<Widget> dropdownButtons = [];
    for (var sort in widget.dropDown) {
      dropdownButtons.add(
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            if (widget.provider == 'projects') {
              context.read<ProjectProvider>().sortProjects(sort);
            } else {
              context.read<RobotProvider>().sortRobots(sort);
            }
          },
          child: SizedBox(
            height: 25 * widget.dropDown.length.toDouble(),
            child: Center(
              child: Text(sort),
            ),
          ),
        ),
      );
    }
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      children: ListTile.divideTiles(
        color: Colors.black,
        context: context,
        tiles: dropdownButtons,
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(20),
      title: const Text('Sort'),
      content: SizedBox(
        height: 50 * widget.dropDown.length.toDouble(),
        width: double.maxFinite,
        child: getDropDown(),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
