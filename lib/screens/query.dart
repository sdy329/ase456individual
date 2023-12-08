import 'package:flutter/material.dart';

class QueryScreen extends StatefulWidget {
  const QueryScreen({Key? key}) : super(key: key);

  @override
  State<QueryScreen> createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  final _queryController = TextEditingController();

  var sampleList = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  var queryList = [];

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _searchList(String query) {
    List<String> searchList = [];
    for (int i = 0; i < sampleList.length; i++) {
      if (sampleList[i].contains(query)) {
        searchList.add(sampleList[i]);
      }
    }
    setState(() {
      queryList = searchList;
    });
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
                _searchList(value);
                _showSnackBar('Searching for $value');
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
                    title: Text(queryList[index]),
                    onTap: () {
                      _showSnackBar(queryList[index] + ' tapped');
                    },
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
