import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PriorityScreen extends StatefulWidget {
  const PriorityScreen({Key? key}) : super(key: key);

  @override
  State<PriorityScreen> createState() => _PriorityScreenState();
}

class _PriorityScreenState extends State<PriorityScreen> {
  var queryList = [];

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _sortDatabaseByPriority() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('records').get();

      Map<String, int> tagDurationMap = {};

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final tag = data['tag'] as String;
        final duration = data['duration'] as int;

        tagDurationMap[tag] = (tagDurationMap[tag] ?? 0) + duration;
      }

      queryList = tagDurationMap.entries
          .map((entry) => {'tag': entry.key, 'duration': entry.value})
          .toList();

      queryList.sort((a, b) => b['duration'].compareTo(a['duration']));

      setState(() {});
    } catch (e) {
      _showSnackBar('Error sorting database: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _sortDatabaseByPriority();
    return Scaffold(
      body: Column(
        children: [
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
                    title: Text(queryList[index]['tag'].toString()),
                    subtitle: Text(
                        'Time Spent: ${queryList[index]['duration'].toString()} minutes'),
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
