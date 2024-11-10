import 'package:flutter/material.dart';
import 'screens/placement_panel.dart';


class PlacementPanelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Placement Panel',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PlacementPanel(),
    );
  }
}
