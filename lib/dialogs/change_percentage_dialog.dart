import 'package:flutter/material.dart';

import 'package:robo_works/models/robot.dart';
import 'package:robo_works/services/database/robot_service.dart';

class ChangePercentageDialog extends StatefulWidget {
  final Robot robot;
  final String phase;
  final String sectionName;
  final String section;
  final int value;
  const ChangePercentageDialog(
      {Key? key, required this.robot,  required this.phase, required this.sectionName, required this.section, required this.value})
      : super(key: key);

  @override
  State<ChangePercentageDialog> createState() => _ChangePercentageDialogState();
}

class _ChangePercentageDialogState extends State<ChangePercentageDialog> {
  int percentage = 0;

  @override
  void initState() {
    percentage = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(20),
      title: Text(widget.sectionName),
      content: SizedBox(
        height: 75,
        width: double.maxFinite,
        child: Slider(
          value: percentage.toDouble(),
          min: 0,
          max: 100,
          onChanged: (newPercentage) {
            setState(() {
              percentage = newPercentage.round();
            });
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Confirm'),
          onPressed: () {
            Navigator.of(context).pop();
            RobotService(projectId: widget.robot.project).setSectionPercentage(widget.robot.id, widget.phase, widget.section, percentage);
          },
        ),
      ],
    );
  }
}
