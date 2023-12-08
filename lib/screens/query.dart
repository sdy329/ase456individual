import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class QueryScreen extends StatefulWidget {
  const QueryScreen({Key? key}) : super(key: key);

  @override
  State<QueryScreen> createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  final _queryController = TextEditingController();

  var queryList = [];

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _searchDatabaseLocally(String query) async {
    try {
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
        if (_containsIgnoreCase(result['task'], query) ||
            result['tag'] == query ||
            (_isDateFormat(query) &&
                _formatTimestamp(result['date']) == query) ||
            (query == 'today' && _isToday(result['date']))) {
          result['date'] = _formatTimestamp(result['date']);
          searchResults.add(result);
        }
      }

      setState(() {
        queryList = searchResults;
      });

      _showSnackBar('Searching for $query');
    } catch (e) {
      _showSnackBar('Error searching database: $e');
    }
  }

  bool _isToday(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateTime today = DateTime.now();
    return dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day;
  }

  bool _containsIgnoreCase(String text, String query) {
    return text.toLowerCase().contains(query.toLowerCase());
  }

  bool _isDateFormat(String input) {
    try {
      DateFormat('yyyy/MM/dd').parse(input);
      return true;
    } catch (e) {
      return false;
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
            child: TextField(
              controller: _queryController,
              decoration: const InputDecoration(
                labelText: 'Query',
                hintText: 'Enter query',
              ),
              onSubmitted: (String value) {
                _searchDatabaseLocally(value);
              },
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
