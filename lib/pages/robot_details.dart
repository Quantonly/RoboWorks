import 'package:flutter/material.dart';
import 'package:robo_works/models/robot.dart';

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
    Map<String, dynamic> phases = widget.robot.phases;
    List<String> names = [];
    List<int> values = [];
    names.addAll([
      'Setup Controller',
      'Setup Network',
      'Commissioning Equipment',
      'Load OLP',
      'Payloads'
    ]);
    values.addAll([
      phases['phase_1']['setup_controller'] ?? 0,
      phases['phase_1']['setup_network'] ?? 0,
      phases['phase_1']['commissioning_equipment'] ?? 0,
      phases['phase_1']['load_olp'] ?? 0,
      phases['phase_1']['payloads'] ?? 0
    ]);
    items[0].body = phaseAttributes(names, values);
    items[0].percentage =
        (values.reduce((a, b) => a + b).toDouble() / values.length);
    names = [];
    values = [];
    names.addAll(['Load/Activate Safety', 'Check Safety', 'Safety Buy-off']);
    values.addAll([
      phases['phase_2']['load_activate_safety'] ?? 0,
      phases['phase_2']['check_safety'] ?? 0,
      phases['phase_2']['safety_buy_off'] ?? 0
    ]);
    items[1].body = phaseAttributes(names, values);
    items[1].percentage =
        (values.reduce((a, b) => a + b).toDouble() / values.length);
    names = [];
    values = [];
    names.addAll([
      'Cell Alignment',
      'Check TCP\'s',
      'Check Base/WorkObjects/Uframe',
      'Check/Teach Docking Routines',
      'Check/Teach Service Routines',
      'Check/Teach Production Paths',
      'Check Collision Zoning'
    ]);
    values.addAll([
      phases['phase_3']['cell_alignment'] ?? 0,
      phases['phase_3']['check_tcp'] ?? 0,
      phases['phase_3']['check_base_workobjects_uframe'] ?? 0,
      phases['phase_3']['check_teach_docking_routines'] ?? 0,
      phases['phase_3']['check_teach_service_routines'] ?? 0,
      phases['phase_3']['check_teach_production_paths'] ?? 0,
      phases['phase_3']['check_collision_zoning'] ?? 0
    ]);
    items[2].body = phaseAttributes(names, values);
    items[2].percentage =
        (values.reduce((a, b) => a + b).toDouble() / values.length);
    names = [];
    values = [];
    names.addAll([
      'Automatic Test Service Routines',
      'Dryrun',
      'Build Parts',
      'Cycletime Achieved'
    ]);
    values.addAll([
      phases['phase_4']['automatic_test_service_routines'] ?? 0,
      phases['phase_4']['dryrun'] ?? 0,
      phases['phase_4']['build_parts'] ?? 0,
      phases['phase_4']['cycletime_achieved'] ?? 0
    ]);
    items[3].body = phaseAttributes(names, values);
    items[3].percentage =
        (values.reduce((a, b) => a + b).toDouble() / values.length);
    names = [];
    values = [];
    names.addAll(['Robot Documentation', 'Bob Ready']);
    values.addAll([
      phases['phase_5']['robot_documentation'] ?? 0,
      phases['phase_5']['bob_ready'] ?? 0
    ]);
    items[4].body = phaseAttributes(names, values);
    items[4].percentage =
        (values.reduce((a, b) => a + b).toDouble() / values.length);
  }

  Widget phaseAttributes(List<String> names, List<int> values) {
    return SizedBox(
      height: names.length * 72,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: names.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(names[index]),
            subtitle: Text(values[index].toString() + "%"),
            trailing: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.keyboard_arrow_right),
            ),
            onTap: () {
              //
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
