import 'package:flutter/material.dart';

class SortDialog extends StatelessWidget {
  final List<String> dropDown;
  const SortDialog({Key? key, required this.dropDown}) : super(key: key);

  Widget getDropDown() {
    List<Widget> dropdownButtons = [];
    for (var sort in dropDown) {
      dropdownButtons.add(Text(sort));
    }
    return Column(children: dropdownButtons,);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(20),
      title: const Text('Sort'),
      content: SizedBox(
        height: 50 * dropDown.length.toDouble(),
        width: double.maxFinite,
        child: getDropDown(),
      ),
    );
  }
}
