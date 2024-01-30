import 'package:flutter/material.dart';

class LeapYear extends StatefulWidget {
  const LeapYear({super.key});

  @override
  State<LeapYear> createState() => _LeapYearState();
}

class _LeapYearState extends State<LeapYear> {
  final TextEditingController _yearController = TextEditingController();
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Leap Year Checker'),
        backgroundColor: Colors.grey[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter a year',
                hintText: 'e.g., 2024',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _result = isLeapYear(int.tryParse(_yearController.text));
                });
              },
              child: const Text('Check Leap Year'),
            ),
            const SizedBox(height: 20),
            Text(
              _result,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  String isLeapYear(int? year) {
    if (year == null) {
      return 'Please enter a valid year';
    } else {
      if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
        return '$year is a leap year';
      } else {
        return '$year is not a leap year';
      }
    }
  }
}
