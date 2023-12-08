import 'package:flutter/material.dart';
import 'screens/record.dart';
import 'screens/query.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int tab = 0;
  String title = 'Record';

  void selectItem(int itemIndex, [String titleUpdate = 'Record']) {
    setState(() {
      tab = itemIndex;
      title = titleUpdate;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: [
        const RecordScreen(),
        const QueryScreen(),
        //ReportScreen(),
        //PriorityScreen(),
      ][tab],
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.record_voice_over_outlined),
              title: const Text('Record'),
              onTap: () {
                selectItem(0, 'Record');
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Query'),
              onTap: () {
                selectItem(1, 'Query');
              },
            ), /*
            ListTile(
              leading: const Icon(Icons.view_timeline_outlined),
              title: const Text('Report'),
              onTap: () {
                selectItem(2, 'Report');
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer_outlined),
              title: const Text('Priority'),
              onTap: () {
                selectItem(3, 'Priority');
              },
            ),*/
          ],
        ),
      ),
    );
  }
}
