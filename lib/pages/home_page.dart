import 'package:flutter/material.dart';
import 'package:lifechrono/pages/add_family_members_page.dart';
import 'package:lifechrono/pages/age_cal_page.dart';
import 'package:lifechrono/pages/age_comp_page.dart';
import 'package:lifechrono/pages/bmi_page.dart';
import 'package:lifechrono/pages/date_cal_page.dart';
import 'package:lifechrono/pages/leap_year_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List of data for each card
  final List<Map<String, dynamic>> cardData = [
    {'icon': Icons.calculate_outlined, 'text': 'Age Calculator'},
    {'icon': Icons.calendar_month, 'text': 'Date Calculator'},
    {'icon': Icons.compare_outlined, 'text': 'Age Comparison'},
    {'icon': Icons.calendar_today_outlined, 'text': 'Leap Year'},
    {'icon': Icons.manage_accounts, 'text': 'Add Family Member'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Age Calc',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      body: Center(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: cardData.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Navigate to the respective calculator page when the card is clicked
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AgeCalculator()),
                  );
                } else if (index == 1) {
                  //Navigate to Weight Calculator Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DateCalculator()),
                  );
                } else if (index == 2) {
                  //Navigate to Weight Calculator Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AgeCompare()),
                  );
                } else if (index == 3) {
                  //Navigate to Weight Calculator Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LeapYear()),
                  );
                } else if (index == 4) {
                  //Navigate to Weight Calculator Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddFamilyMembers()),
                  );
                } else if (index == 5) {
                  //Navigate to Weight Calculator Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Bmi()),
                  );
                } // Add more conditions for other calculator types if needed
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  color: Colors.grey[100],
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        cardData[index]['icon'],
                        size: 60.0,
                        color: Colors.orange[600],
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        cardData[index]['text'],
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
