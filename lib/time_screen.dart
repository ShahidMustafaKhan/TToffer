import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class TimeScreen extends StatefulWidget {
  @override
  _TimeScreenState createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  List<DateTime> randomDateTimes = [
    DateTime(2022, 10, 9, 2, 30),
    DateTime(2022, 8, 15, 10, 0),
    DateTime(2023, 5, 20, 18, 45),
    DateTime(2024, 5, 16, 18, 45),
    DateTime(2024, 4, 16, 18, 45),
    DateTime(2024, 5, 14, 18, 45),
  ];

  List<String> formattedDateTimes = [];

  @override
  void initState() {
    super.initState();
    calculateTimeDifferences();
  }

  void calculateTimeDifferences() {
    DateTime currentDateTime = DateTime.now();
    for (DateTime dateTime in randomDateTimes) {
      Duration difference = currentDateTime.difference(dateTime);
      int days = difference.inDays;
      int hours = difference.inHours % 24;
      String formattedDateTime = '$days days and $hours hr ago';
      formattedDateTimes.add(formattedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date Time Comparison'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: randomDateTimes.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                'Target Date Time: ${DateFormat('yyyy-MM-dd hh:mm a').format(randomDateTimes[index])}',
                style: TextStyle(fontSize: 16),
              ),
              subtitle: Text(
                'Time Difference: ${formattedDateTimes[index]}',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ),
    );
  }
}
