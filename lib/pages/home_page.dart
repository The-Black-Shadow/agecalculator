import 'package:flutter/material.dart';

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
    {'icon': Icons.more_horiz, 'text': 'More'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Age Calculator',
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
                // Navigate to a certain page when the card is clicked
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => DetailPage(index)),
                // );
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