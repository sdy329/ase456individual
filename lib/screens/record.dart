import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final _dateController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _taskController = TextEditingController();
  final _tagController = TextEditingController();

  DateTime? _date;
  var _from = '';
  var _to = '';
  String _task = '';
  String _tag = '';
  int _duration = 0;
  bool _submitting = false;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  bool _validateTime(String fromTime, String toTime) {
    if (int.parse(toTime.split(':')[0]) < int.parse(fromTime.split(':')[0])) {
      return false;
    } else if (int.parse(toTime.split(':')[1]) <
        int.parse(fromTime.split(':')[1])) {
      return false;
    }
    return true;
  }

  int _calculateDuration(String fromTime, String toTime) {
    int fromHour = int.parse(fromTime.split(':')[0]);
    int fromMinute = int.parse(fromTime.split(':')[1]);
    int toHour = int.parse(toTime.split(':')[0]);
    int toMinute = int.parse(toTime.split(':')[1]);

    int hourDiff = toHour - fromHour;
    int minuteDiff = toMinute - fromMinute;

    return hourDiff * 60 + minuteDiff;
  }

  void _submitRecord() async {
    _submitting = true;
    try {
      if (_date == null && _dateController.text.isEmpty) {
        _showSnackBar('Date is empty');
        _submitting = false;
        return;
      } else if (_date == null && _dateController.text.isNotEmpty) {
        _showSnackBar('Date is invalid');
        _submitting = false;
        return;
      }
      if (_from.isEmpty) {
        _showSnackBar('From is empty');
        _submitting = false;
        return;
      }
      if (_to.isEmpty) {
        _showSnackBar('To is empty');
        _submitting = false;
        return;
      }
      if (_task.isEmpty) {
        _showSnackBar('Task is empty');
        _submitting = false;
        return;
      }
      if (_tag.isEmpty) {
        _showSnackBar('Tag is empty');
        _submitting = false;
        return;
      }
      if (!_validateTime(_from, _to)) {
        _showSnackBar('To time is before from time');
        _submitting = false;
        return;
      }
      _duration = _calculateDuration(_from, _to);

      Map<String, dynamic> recordData = {
        'date': _date,
        'from': _from,
        'to': _to,
        'task': _task,
        'tag': _tag,
        'duration': _duration,
      };

      await FirebaseFirestore.instance.collection('records').add(recordData);

      _showSnackBar('Record submitted successfully');
      _submitting = false;
    } catch (e) {
      _showSnackBar('Error submitting record: $e');
      _submitting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double boxWidth = MediaQuery.of(context).size.width * 0.4;
    final double fullWidth = MediaQuery.of(context).size.width * 0.9;
    const double rowSpacer = 40.0;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              // Date + From
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: boxWidth,
                  child: TextField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Date',
                    ),
                    onChanged: (String value) async {
                      if (value.isEmpty) return;
                      try {
                        if (value == 'today') {
                          _date = DateFormat('yyyy/MM/dd').parse(DateTime.now()
                              .toString()
                              .substring(0, 10)
                              .replaceAll('-', '/'));
                        } else {
                          _date = DateFormat('yyyy/MM/dd').parse(value);
                        }
                      } catch (e) {
                        return;
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: boxWidth,
                  child: TextField(
                    controller: _fromController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'From',
                    ),
                    onChanged: (String value) async {
                      if (value.isEmpty) return;
                      try {
                        if (value.contains('AM')) {
                          _from = value.replaceAll('AM', '');
                        } else if (value.contains('PM')) {
                          _from =
                              '${int.parse(value.replaceAll('PM', '').split(':')[0]) + 12}:${value.replaceAll('PM', '').split(':')[1]}';
                        } else {
                          _from = value;
                        }
                      } catch (e) {
                        _showSnackBar('Invalid time format');
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: rowSpacer),
            Row(
              // Task + To
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: boxWidth,
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Task',
                    ),
                    onChanged: (String value) async {
                      if (value.isEmpty) return;
                      _task = value;
                    },
                  ),
                ),
                SizedBox(
                  width: boxWidth,
                  child: TextField(
                    controller: _toController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'To',
                    ),
                    onChanged: (String value) async {
                      if (value.isEmpty) return;
                      try {
                        if (value.contains('AM')) {
                          _to = value.replaceAll('AM', '');
                        } else if (value.contains('PM')) {
                          _to =
                              '${int.parse(value.replaceAll('PM', '').split(':')[0]) + 12}:${value.replaceAll('PM', '').split(':')[1]}';
                        } else {
                          _to = value;
                        }
                      } catch (e) {
                        _showSnackBar('Invalid time format');
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: rowSpacer),
            Row(
              // Tag
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: boxWidth,
                  child: TextField(
                    controller: _tagController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Tag',
                    ),
                    onChanged: (String value) async {
                      if (value.isEmpty) return;
                      if (value.contains(' ')) {
                        return;
                      } else if (value[0] != ':') {
                        return;
                      }
                      _tag = value;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: rowSpacer),
            SizedBox(
              width: fullWidth,
              child: ElevatedButton(
                onPressed: () {
                  if (_submitting) return;
                  _showSnackBar('Submitting record');
                  _submitRecord();
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
