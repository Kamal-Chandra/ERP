import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeesPage extends StatefulWidget {
  final int studentId;

  const FeesPage({Key? key, required this.studentId}) : super(key: key);

  @override
  _FeesPageState createState() => _FeesPageState();
}

class _FeesPageState extends State<FeesPage> {
  List<dynamic> _unpaidFees = [];
  List<dynamic> _filteredFees = [];
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUnpaidFees();
    _searchController.addListener(() {
      filterFees(_searchController.text);
    });
  }

  Future<void> _fetchUnpaidFees() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost:3000/unpaid-fees/details/${widget.studentId}'));
      if (response.statusCode == 200) {
        setState(() {
          _unpaidFees = json.decode(response.body);
          _filteredFees = _unpaidFees;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _error = 'Error fetching fees';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error fetching fees: $e';
      });
    }
  }

  void filterFees(String query) {
    setState(() {
      _filteredFees = _unpaidFees.where((fee) {
        final feeType = fee['fee_type'].toLowerCase();
        return feeType.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Unpaid Fees',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search fees',
                prefixIcon: Icon(Icons.search, color: Colors.white),
                hintStyle: TextStyle(color: Colors.white),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : _error != null
                    ? Expanded(
                        child: Center(
                          child: Text(
                            _error!,
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          ),
                        ),
                      )
                    : _filteredFees.isEmpty
                        ? Expanded(
                            child: Center(
                              child: Text(
                                'No pending fees',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: _filteredFees.length,
                              itemBuilder: (context, index) {
                                final fee = _filteredFees[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ListTile(
                                    title: Text(
                                      fee['fee_type'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 4),
                                        Text(
                                          'Amount: ${fee['amount']}',
                                          style:
                                              TextStyle(color: Colors.white70),
                                        ),
                                        Text(
                                          'Due Date: ${_formatDate(fee['due_date'])}',
                                          style:
                                              TextStyle(color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                    tileColor: Colors.black,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateTime) {
    final DateTime date = DateTime.parse(dateTime);
    return '${date.day}/${date.month}/${date.year}';
  }
}