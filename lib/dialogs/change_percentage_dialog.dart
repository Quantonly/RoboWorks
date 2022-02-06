import 'package:flutter/material.dart';

class ChangePercentageDialog extends StatefulWidget {
  final String name;
  final int value;
  const ChangePercentageDialog(
      {Key? key, required this.name, required this.value})
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
      title: Text(widget.name),
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
          },
        ),
      ],
    );
  }
}
