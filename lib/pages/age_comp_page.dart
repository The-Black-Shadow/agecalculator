import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AgeCompare extends StatefulWidget {
  const AgeCompare({super.key});

  @override
  State<AgeCompare> createState() => _AgeCompareState();
}

class _AgeCompareState extends State<AgeCompare> {
  final TextEditingController _initial_Date_Controller =
      TextEditingController();
  final TextEditingController _final_Date_Controller = TextEditingController();
  final finalDate = DateTime.now();
  String _result = '';
  String comparisonMessage = '';

  @override
  void initState() {
    super.initState();
    _initial_Date_Controller.text = DateFormat('yyyy-MM-dd').format(finalDate);
    _final_Date_Controller.text = DateFormat('yyyy-MM-dd').format(finalDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[200],
        title: Text(
          'Age Comparison',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: GoogleFonts.audiowide().fontFamily,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            const SizedBox(height: 20),
            Text(
              'Select first person birth date : ',
              style: TextStyle(
                fontFamily: GoogleFonts.audiowide().fontFamily,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _initial_Date_Controller,
                readOnly: true,
                onTap: () async {
                  final DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    _initial_Date_Controller.text =
                        DateFormat('yyyy-MM-dd').format(date);
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Select First Birth Date',
                  hintText: 'Select First Birth Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select second person birth date : ',
              style: TextStyle(
                fontFamily: GoogleFonts.audiowide().fontFamily,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _final_Date_Controller,
                readOnly: true,
                onTap: () async {
                  final DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    _final_Date_Controller.text =
                        DateFormat('yyyy-MM-dd').format(date);
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Select Second Birth Date',
                  hintText: 'Select Second Birth Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final initialDate = DateFormat('yyyy-MM-dd')
                    .parse(_initial_Date_Controller.text);
                final finalDate =
                    DateFormat('yyyy-MM-dd').parse(_final_Date_Controller.text);
                final age = calculateAge(finalDate, initialDate);
                if (initialDate.isAfter(finalDate)) {
                  comparisonMessage =
                      'Second person is older than the first person';
                } else if (initialDate.isBefore(finalDate)) {
                  comparisonMessage =
                      'First person is older than the second person';
                } else {
                  comparisonMessage = 'Both persons are of the same age';
                }
                setState(() {
                  comparisonMessage = comparisonMessage;
                  _result = age;
                });
              },
              child: Text(
                'Calculate',
                style: TextStyle(
                  fontFamily: GoogleFonts.audiowide().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Congratulations : $comparisonMessage',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontFamily: GoogleFonts.audiowide().fontFamily,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Age Difference : $_result',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontFamily: GoogleFonts.audiowide().fontFamily,
                ),
              ),
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  color: Colors.grey[200],
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total Months: ${calculateTotalMonths(_result)} months ${calculateRemainingDays(_result)} days',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: GoogleFonts.audiowide().fontFamily,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Total Weeks: ${calculateTotalWeeks(_result)} weeks ${calculateRemainingDaysAfterWeeks(_result)} days',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: GoogleFonts.audiowide().fontFamily,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Total Minutes: ${calculateTotalMinutes(_result)} minutes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: GoogleFonts.audiowide().fontFamily,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Total Hours: ${calculateTotalHours(_result)} hours',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: GoogleFonts.audiowide().fontFamily,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Total Days: ${calculateTotalDays(_result)} days',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: GoogleFonts.audiowide().fontFamily,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              // Concatenate all age-related information
                              String allInfo = '''
                                Your Age is: $_result
                                  Total Months: ${calculateTotalMonths(_result)} months ${calculateRemainingDays(_result)} days
                                  Total Weeks: ${calculateTotalWeeks(_result)} weeks ${calculateRemainingDaysAfterWeeks(_result)} days
                                  Total Hours: ${calculateTotalHours(_result)} hours
                                  Total Minutes: ${calculateTotalMinutes(_result)} minutes
                                  Total Days: ${calculateTotalDays(_result)} days
                                ''';

                              // Copy the entire result to the clipboard
                              Clipboard.setData(ClipboardData(text: allInfo));

                              // Show a snackbar indicating that the text is copied
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Copied to clipboard'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String calculateAge(DateTime finalDate, DateTime initialDate) {
    int years = finalDate.year - initialDate.year;
    int months = finalDate.month - initialDate.month;
    int days = finalDate.day - initialDate.day;

    if (months < 0 || (months == 0 && days < 0)) {
      years--;
      months += 12;
    }

    return '$years years $months months $days days';
  }

  int calculateTotalMonths(String age) {
    List<String> parts = age.split(' ');
    int years = int.parse(parts[0]);
    int months = int.parse(parts[2]);
    return years * 12 + months;
  }

  int calculateRemainingDays(String age) {
    List<String> parts = age.split(' ');
    return int.parse(parts[4]);
  }

  int calculateTotalWeeks(String age) {
    DateTime initialDate =
        DateFormat('yyyy-MM-dd').parse(_initial_Date_Controller.text);
    DateTime finalDate =
        DateFormat('yyyy-MM-dd').parse(_final_Date_Controller.text);
    int differenceInSeconds = (finalDate.millisecondsSinceEpoch -
            initialDate.millisecondsSinceEpoch) ~/
        1000;
    return (differenceInSeconds / 604800).floor();
  }

  int calculateRemainingDaysAfterWeeks(String age) {
    DateTime initialDate =
        DateFormat('yyyy-MM-dd').parse(_initial_Date_Controller.text);
    DateTime finalDate =
        DateFormat('yyyy-MM-dd').parse(_final_Date_Controller.text);
    int differenceInSeconds = (finalDate.millisecondsSinceEpoch -
            initialDate.millisecondsSinceEpoch) ~/
        1000;
    int remainingSeconds = differenceInSeconds % 604800;
    return (remainingSeconds / 86400).floor();
  }

  int calculateTotalHours(String age) {
    DateTime initialDate =
        DateFormat('yyyy-MM-dd').parse(_initial_Date_Controller.text);
    DateTime finalDate =
        DateFormat('yyyy-MM-dd').parse(_final_Date_Controller.text);
    int differenceInSeconds = (finalDate.millisecondsSinceEpoch -
            initialDate.millisecondsSinceEpoch) ~/
        1000;
    return (differenceInSeconds / 3600).floor();
  }

  int calculateTotalMinutes(String age) {
    DateTime initialDate =
        DateFormat('yyyy-MM-dd').parse(_initial_Date_Controller.text);
    DateTime finalDate =
        DateFormat('yyyy-MM-dd').parse(_final_Date_Controller.text);
    int differenceInSeconds = (finalDate.millisecondsSinceEpoch -
            initialDate.millisecondsSinceEpoch) ~/
        1000;
    return (differenceInSeconds / 60).floor();
  }

  int calculateTotalDays(String age) {
    DateTime initialDate =
        DateFormat('yyyy-MM-dd').parse(_initial_Date_Controller.text);
    DateTime finalDate =
        DateFormat('yyyy-MM-dd').parse(_final_Date_Controller.text);
    int differenceInSeconds = (finalDate.millisecondsSinceEpoch -
            initialDate.millisecondsSinceEpoch) ~/
        1000;
    return (differenceInSeconds / 86400).floor();
  }
}
