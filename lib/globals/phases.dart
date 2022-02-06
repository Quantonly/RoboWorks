Map<String, dynamic> sections = {
  'phase_1': [
    'setup_controller',
    'setup_network',
    'commissioning_equipment',
    'load_olp',
    'payloads',
  ],
  'phase_2': [
    'load_activate_safety',
    'check_safety',
    'safety_buy_off',
  ],
  'phase_3': [
    'cell_alignment',
    'check_tcp',
    'check_base_workobjects_uframe',
    'check_teach_docking_routines',
    'check_teach_service_routines',
    'check_teach_production_paths',
    'check_collision_zoning'
  ],
  'phase_4': [
    'automatic_test_service_routines',
    'dryrun',
    'build_parts',
    'cycletime_achieved'
  ],
  'phase_5': [
    'robot_documentation',
    'bob_ready',
  ]
};
Map<String, dynamic> sectionNames = {
  'phase_1': [
    'Setup Controller',
    'Setup Network',
    'Commissioning Equipment',
    'Load OLP',
    'Payloads',
  ],
  'phase_2': [
    'Load/Activate Safety',
    'Check Safety',
    'Safety Buy-off',
  ],
  'phase_3': [
    'Cell Alignment',
    'Check TCP\'s',
    'Check Base/WorkObjects/Uframe',
    'Check/Teach Docking Routines',
    'Check/Teach Service Routines',
    'Check/Teach Production Paths',
    'Check Collision Zoning'
  ],
  'phase_4': [
    'Automatic Test Service Routines',
    'Dryrun',
    'Build Parts',
    'Cycletime Achieved'
  ],
  'phase_5': [
    'Robot Documentation',
    'Bob Ready',
  ]
};
