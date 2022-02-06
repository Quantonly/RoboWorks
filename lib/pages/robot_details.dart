import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:robo_works/dialogs/change_percentage_dialog.dart';
import 'package:robo_works/dialogs/sign_out_dialog.dart';
import 'package:robo_works/glow_behavior.dart';
import 'package:robo_works/models/project.dart';
import 'package:robo_works/models/robot.dart';
import 'package:robo_works/services/database/robot_service.dart';
import 'package:robo_works/globals/phases.dart' as phases;

class RobotDetailsPage extends StatefulWidget {
  final Project project;
  final Robot robot;
  const RobotDetailsPage({Key? key, required this.project, required this.robot})
      : super(key: key);

  @override
  State<RobotDetailsPage> createState() => _RobotDetailsPageState();
}

class _RobotDetailsPageState extends State<RobotDetailsPage> {
  int totalPercentage = 0;
  List<ExpansionItem> items = <ExpansionItem>[
    ExpansionItem(
      false,
      'Phase 1',
      'Setup & Commissioning',
      0,
      const Icon(
        Icons.build,
        color: Color.fromRGBO(223, 223, 223, 1),
      ),
      Container(),
    ),
    ExpansionItem(
      false,
      'Phase 2',
      'Safety',
      0,
      const Icon(
        Icons.health_and_safety,
        color: Color.fromRGBO(223, 223, 223, 1),
      ),
      Container(),
    ),
    ExpansionItem(
      false,
      'Phase 3',
      'Path Verification',
      0,
      const Icon(
        Icons.alt_route,
        color: Color.fromRGBO(223, 223, 223, 1),
      ),
      Container(),
    ),
    ExpansionItem(
      false,
      'Phase 4',
      'Automatic Build',
      0,
      const Icon(
        Icons.autorenew,
        color: Color.fromRGBO(223, 223, 223, 1),
      ),
      Container(),
    ),
    ExpansionItem(
      false,
      'Phase 5',
      'Documentation',
      0,
      const Icon(
        Icons.document_scanner,
        color: Color.fromRGBO(223, 223, 223, 1),
      ),
      Container(),
    ),
  ];

  Future<Robot> _refreshRobot() async {
    Robot robot = await RobotService(projectId: widget.robot.project)
        .getRobot(widget.robot.id);
    widget.robot.phases = robot.phases;
    setState(() {});
    return robot;
  }

  @override
  Widget build(BuildContext context) {
    phaseBuilder();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
        title: const Text(
          'Robot',
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => const SignOutDialog(),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(33, 33, 33, 1),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          CircularPercentIndicator(
            center: Text(
              totalPercentage.toString() + "%",
              style: const TextStyle(
                color: Color.fromRGBO(223, 223, 223, 1),
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            radius: 70.0,
            animation: true,
            animationDuration: 1000,
            lineWidth: 15.0,
            percent: totalPercentage / 100,
            reverse: false,
            arcType: ArcType.FULL,
            startAngle: 0.0,
            animateFromLastPercent: true,
            circularStrokeCap: CircularStrokeCap.round,
            linearGradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              tileMode: TileMode.clamp,
              stops: [0.0, 1.0],
              colors: <Color>[
                Colors.red,
                Colors.green,
              ],
            ),
            arcBackgroundColor: Colors.grey,
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Text(
                'Project name: ' + widget.project.name,
                style: const TextStyle(
                  color: Color.fromRGBO(223, 223, 223, 1),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Robot name: ' + widget.robot.name,
                style: const TextStyle(
                  color: Color.fromRGBO(223, 223, 223, 1),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SizedBox(
              child: RefreshIndicator(
                onRefresh: _refreshRobot,
                child: ScrollConfiguration(
                  behavior: NoGlowBehavior(),
                  child: ListView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            disabledColor:
                                const Color.fromRGBO(223, 223, 223, 1),
                          ),
                          child: ExpansionPanelList(
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                items[index].isExpanded =
                                    !items[index].isExpanded;
                              });
                            },
                            children: items.map((ExpansionItem item) {
                              return ExpansionPanel(
                                canTapOnHeader: true,
                                backgroundColor:
                                    const Color.fromRGBO(66, 66, 66, 1),
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    title: Text(
                                      item.header,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: Color.fromRGBO(223, 223, 223, 1),
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    subtitle: Text(
                                      item.subtitle +
                                          " (" +
                                          item.percentage.toStringAsFixed(0) +
                                          "%)",
                                      style: const TextStyle(
                                        color:
                                            Color.fromRGBO(223, 223, 223, 0.7),
                                      ),
                                    ),
                                    leading: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  phaseBuilder() {
    int index = 0;
    int total = 0;
    int totalValues = 0;
    phases.sections.forEach((key, value) {
      List<String> sectionNames = [];
      List<int> values = [];
      List<String> phaseValues = value as List<String>;
      for (var section in phaseValues) {
        values.add(widget.robot.phases[key][section] ?? 0);
        totalValues++;
      }
      sectionNames.addAll(phases.sectionNames[key]);
      items[index].body = phaseAttributes(key, sectionNames, values);
      items[index].percentage =
          (values.reduce((a, b) => a + b).toDouble() / values.length);
      total += (values.reduce((a, b) => a + b).toDouble()).round();
      index++;
    });
    totalPercentage = (total / totalValues).round();
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
            title: Text(
              sectionNames[index],
              style: const TextStyle(
                color: Color.fromRGBO(223, 223, 223, 1),
              ),
            ),
            subtitle: Text(
              values[index].toString() + "%",
              style: const TextStyle(
                color: Color.fromRGBO(223, 223, 223, 0.7),
              ),
            ),
            trailing: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.edit,
                color: Color.fromRGBO(223, 223, 223, 1),
              ),
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
              ).then((value) => setState(() {}));
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
