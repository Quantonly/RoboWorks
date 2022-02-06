import 'package:flutter/material.dart';
import 'package:robo_works/dialogs/change_percentage_dialog.dart';
import 'package:robo_works/models/robot.dart';
import 'package:robo_works/globals/phases.dart' as phases;

class RobotDetailsPage extends StatefulWidget {
  final Robot robot;
  const RobotDetailsPage({Key? key, required this.robot}) : super(key: key);

  @override
  State<RobotDetailsPage> createState() => _RobotDetailsPageState();
}

class _RobotDetailsPageState extends State<RobotDetailsPage> {
  List<ExpansionItem> items = <ExpansionItem>[
    ExpansionItem(
      false,
      'Phase 1',
      'Setup & Commissioning',
      0,
      const Icon(Icons.build),
      Container(),
    ),
    ExpansionItem(
      false,
      'Phase 2',
      'Safety',
      0,
      const Icon(Icons.health_and_safety),
      Container(),
    ),
    ExpansionItem(
      false,
      'Phase 3',
      'Path Verification',
      0,
      const Icon(Icons.alt_route),
      Container(),
    ),
    ExpansionItem(
      false,
      'Phase 4',
      'Automatic Build',
      0,
      const Icon(Icons.autorenew),
      Container(),
    ),
    ExpansionItem(
      false,
      'Phase 5',
      'Documentation',
      0,
      const Icon(Icons.document_scanner),
      Container(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    phaseBuilder();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 33, 33, 1),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 150,
          ),
          Text(
            widget.robot.id,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 50,
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
              ),
              child: const Center(
                child: Text(
                  'Go Back',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 500,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          items[index].isExpanded = !items[index].isExpanded;
                        });
                      },
                      children: items.map((ExpansionItem item) {
                        return ExpansionPanel(
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return ListTile(
                              title: Text(
                                item.header,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              subtitle: Text(item.subtitle +
                                  " (" +
                                  item.percentage.toStringAsFixed(0) +
                                  "%)"),
                              leading: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: item.icon,
                              ),
                            );
                          },
                          isExpanded: item.isExpanded,
                          body: item.body,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  phaseBuilder() {
    int index = 0;
    phases.sections.forEach((key, value) {
      List<String> sectionNames = [];
      List<int> values = [];
      List<String> phaseValues = value as List<String>;
      for (var section in phaseValues) {
        values.add(widget.robot.phases[key][section] ?? 0);
      }
      sectionNames.addAll(phases.sectionNames[key]);
      items[index].body = phaseAttributes(key, sectionNames, values);
      items[index].percentage =
          (values.reduce((a, b) => a + b).toDouble() / values.length);
      index++;
    });
  }

  Widget phaseAttributes(
      String phase, List<String> sectionNames, List<int> values) {
    return SizedBox(
      height: sectionNames.length * 72,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sectionNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(sectionNames[index]),
            subtitle: Text(values[index].toString() + "%"),
            trailing: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.edit),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => ChangePercentageDialog(
                  robot: widget.robot,
                  phase: phase,
                  sectionName: sectionNames[index],
                  section: phases.sections[phase][index],
                  value: values[index],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ExpansionItem {
  bool isExpanded;
  String header;
  String subtitle;
  double percentage;
  Icon icon;
  Widget body;
  ExpansionItem(this.isExpanded, this.header, this.subtitle, this.percentage,
      this.icon, this.body);
}
