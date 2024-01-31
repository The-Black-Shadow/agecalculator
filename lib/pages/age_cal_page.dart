import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:lifechrono/components/ad_helper.dart';

class AgeCalculator extends StatefulWidget {
  const AgeCalculator({super.key});

  @override
  State<AgeCalculator> createState() => _AgeCalculatorState();
}

class _AgeCalculatorState extends State<AgeCalculator> {
  //add
  BannerAd? _bannerAd;
  final TextEditingController _dateController = TextEditingController();
  final currentDate = DateTime.now();
  String _ageResult = '';

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(currentDate);
    _create_bannerAd();
  }

  void _create_bannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: AdHelper.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.grey[200],
          title: Text(
            'Age Calculator',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.audiowide().fontFamily,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Text(
              'Todays Date : ${DateFormat('dd-MM-yyyy').format(currentDate)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: GoogleFonts.audiowide().fontFamily,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Your Date of Birth : ',
              style: TextStyle(
                fontFamily: GoogleFonts.audiowide().fontFamily,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _dateController,
                readOnly: true,
                onTap: () async {
                  final DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    _dateController.text =
                        DateFormat('yyyy-MM-dd').format(date);
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Select Date',
                  hintText: 'Select Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final birthDate =
                    DateFormat('yyyy-MM-dd').parse(_dateController.text);
                final age = calculateAge(birthDate, currentDate);
                setState(() {
                  _ageResult = '$age';
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
                'Your Age is : $_ageResult',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontFamily: GoogleFonts.audiowide().fontFamily,
                ),
              ),
            ),
            if (_ageResult.isNotEmpty) ...[
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(20.0),
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
                          'Total Months: ${calculateTotalMonths(_ageResult)} months ${calculateRemainingDays(_ageResult)} days',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: GoogleFonts.audiowide().fontFamily,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Total Weeks: ${calculateTotalWeeks(_ageResult)} weeks ${calculateRemainingDaysAfterWeeks(_ageResult)} days',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: GoogleFonts.audiowide().fontFamily,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Total Minutes: ${calculateTotalMinutes(_ageResult)} minutes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: GoogleFonts.audiowide().fontFamily,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Total Hours: ${calculateTotalHours(_ageResult)} hours',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: GoogleFonts.audiowide().fontFamily,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Total Days: ${calculateTotalDays(_ageResult)} days',
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
Your Age is: $_ageResult
Total Months: ${calculateTotalMonths(_ageResult)} months ${calculateRemainingDays(_ageResult)} days
Total Weeks: ${calculateTotalWeeks(_ageResult)} weeks ${calculateRemainingDaysAfterWeeks(_ageResult)} days
Total Hours: ${calculateTotalHours(_ageResult)} hours
Total Minutes: ${calculateTotalMinutes(_ageResult)} minutes
Total Days: ${calculateTotalDays(_ageResult)} days
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
        bottomNavigationBar: _bannerAd == null
            ? Container()
            : Container(
                height: 54,
                child: AdWidget(ad: _bannerAd!),
              ));
  }

  String calculateAge(DateTime birthDate, DateTime currentDate) {
    int years = currentDate.year - birthDate.year;
    int months = currentDate.month - birthDate.month;
    int days = currentDate.day - birthDate.day;

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
    DateTime birthDate = DateFormat('yyyy-MM-dd').parse(_dateController.text);
    DateTime currentDate = DateTime.now();
    int differenceInSeconds = (currentDate.millisecondsSinceEpoch -
            birthDate.millisecondsSinceEpoch) ~/
        1000;
    return (differenceInSeconds / 604800).floor();
  }

  int calculateRemainingDaysAfterWeeks(String age) {
    DateTime birthDate = DateFormat('yyyy-MM-dd').parse(_dateController.text);
    DateTime currentDate = DateTime.now();
    int differenceInSeconds = (currentDate.millisecondsSinceEpoch -
            birthDate.millisecondsSinceEpoch) ~/
        1000;
    int remainingSeconds = differenceInSeconds % 604800;
    return (remainingSeconds / 86400).floor();
  }

  int calculateTotalHours(String age) {
    DateTime birthDate = DateFormat('yyyy-MM-dd').parse(_dateController.text);
    DateTime currentDate = DateTime.now();
    int differenceInSeconds = (currentDate.millisecondsSinceEpoch -
            birthDate.millisecondsSinceEpoch) ~/
        1000;
    return (differenceInSeconds / 3600).floor();
  }

  int calculateTotalMinutes(String age) {
    DateTime birthDate = DateFormat('yyyy-MM-dd').parse(_dateController.text);
    DateTime currentDate = DateTime.now();
    int differenceInSeconds = (currentDate.millisecondsSinceEpoch -
            birthDate.millisecondsSinceEpoch) ~/
        1000;
    return (differenceInSeconds / 60).floor();
  }

  int calculateTotalDays(String age) {
    DateTime birthDate = DateFormat('yyyy-MM-dd').parse(_dateController.text);
    DateTime currentDate = DateTime.now();
    int differenceInSeconds = (currentDate.millisecondsSinceEpoch -
            birthDate.millisecondsSinceEpoch) ~/
        1000;
    return (differenceInSeconds / 86400).floor();
  }
}
