import 'package:college/Placement/widgets/company_title.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/stat_card.dart';

class PlacementPanel extends StatefulWidget {
  @override
  _PlacementPanelState createState() => _PlacementPanelState();
}

class _PlacementPanelState extends State<PlacementPanel> {
  int totalStudents = 600;
  int totalApplications = 1400;
  int shortlisted = 46;
  int recruited = 0;

  List<dynamic> companies = [];

  @override
  void initState() {
    super.initState();
    fetchCompanies();
  }

  Future<void> fetchCompanies() async {
    final fetchedCompanies = await ApiService.getCompanies();
    setState(() {
      companies = fetchedCompanies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Placement Panel')),
      body: Column(
        children: [
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatCard(title: 'Institutions', value: 1),
              StatCard(title: 'Students', value: totalStudents),
              StatCard(title: 'Applications', value: totalApplications),
              StatCard(title: 'Shortlisted', value: shortlisted),
              StatCard(title: 'Recruited', value: recruited),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: companies.length,
              itemBuilder: (context, index) {
                var company = companies[index];
                return CompanyTile(company: company);
              },
            ),
          ),
        ],
      ),
    );
  }
}
