import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  var queryList = [];
  DateTime? _startDate;
  DateTime? _endDate;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _searchBetweenDates(DateTime? startDate, DateTime? endDate) async {
    try {
      if (startDate == null || endDate == null) {
        _showSnackBar('Invalid date range');
        return;
      }

      CollectionReference records =
          FirebaseFirestore.instance.collection('records');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await records.get() as QuerySnapshot<Map<String, dynamic>>;

      List<Map<String, dynamic>> allResults = querySnapshot.docs
          .map((DocumentSnapshot<Map<String, dynamic>> document) =>
              document.data()!)
          .toList();

      List<Map<String, dynamic>> searchResults = [];

      for (var result in allResults) {
        DateTime recordDate = result['date'].toDate();

        if (recordDate.isAfter(startDate.subtract(Duration(days: 1))) &&
            recordDate.isBefore(endDate.add(Duration(days: 1)))) {
          result['date'] = _formatTimestamp(result['date']);
          searchResults.add(result);
        }
      }

      setState(() {
        queryList = searchResults;
      });

      _showSnackBar(
          'Searching between ${startDate.toString().substring(0, 10).replaceAll('-', '/')} and ${endDate.toString().substring(0, 10).replaceAll('-', '/')}');
    } catch (e) {
      _showSnackBar('Error searching database: $e');
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy/MM/dd').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: TextField(
                      controller: _startDateController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Start Date',
                      ),
                      onChanged: (String value) async {
                        if (value.isEmpty) return;
                        try {
                          if (value == 'today') {
                            _startDate = DateFormat('yyyy/MM/dd').parse(
                                DateTime.now()
                                    .toString()
                                    .substring(0, 10)
                                    .replaceAll('-', '/'));
                          } else {
                            _startDate = DateFormat('yyyy/MM/dd').parse(value);
                          }
                        } catch (e) {
                          return;
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: _endDateController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'End Date',
                      ),
                      onChanged: (String value) async {
                        if (value.isEmpty) return;
                        try {
                          if (value == 'today') {
                            _endDate = DateFormat('yyyy/MM/dd').parse(
                                DateTime.now()
                                    .toString()
                                    .substring(0, 10)
                                    .replaceAll('-', '/'));
                          } else {
                            _endDate = DateFormat('yyyy/MM/dd').parse(value);
                          }
                        } catch (e) {
                          return;
                        }
                      },
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _searchBetweenDates(
                      _startDate,
                      _endDate,
                    );
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: queryList.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.grey[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4.0,
                  child: ListTile(
                    title: Text(queryList[index]['task'].toString()),
                    subtitle: Text(
                        'Date: ${queryList[index]['date']} From: ${queryList[index]['from']} To: ${queryList[index]['to']} Tag: ${queryList[index]['tag']}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
