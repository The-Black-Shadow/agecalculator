import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AddFamilyMembers extends StatefulWidget {
  const AddFamilyMembers({Key? key}) : super(key: key);

  @override
  _AddFamilyMembersState createState() => _AddFamilyMembersState();
}

class _AddFamilyMembersState extends State<AddFamilyMembers> {
  TextEditingController nameController = TextEditingController();
  TextEditingController relationController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  List<Map<String, dynamic>> familyMembers = [];

  @override
  void initState() {
    super.initState();
    loadFamilyMembers();
  }

  void loadFamilyMembers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      familyMembers = prefs.getStringList('familyMembers')?.map((member) {
            return Map<String, dynamic>.from(Map<String, dynamic>.fromIterable(
              member.split(','),
              key: (item) => item[0],
              value: (item) => item[1],
            ));
          }).toList() ??
          [];
    });
  }

  void saveFamilyMembers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> membersList = familyMembers.map((member) {
      return member.entries.map((entry) {
        return '${entry.key},${entry.value}';
      }).join(',');
    }).toList();

    prefs.setStringList('familyMembers', membersList);
  }

  Future<void> showAddMemberDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Family Member'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: relationController,
                  decoration: const InputDecoration(labelText: 'Relation'),
                ),
                TextField(
                  controller: birthdateController,
                  readOnly: true,
                  onTap: () async {
                    final DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      birthdateController.text =
                          DateFormat('yyyy-MM-dd').format(date);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Birthdate',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                addFamilyMember();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showEditMemberDialog(int index) async {
    Map<String, dynamic> member = familyMembers[index];

    nameController.text = member['Name'];
    relationController.text = member['Relation'];
    birthdateController.text = member['Birthdate'];

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Family Member'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: relationController,
                  decoration: const InputDecoration(labelText: 'Relation'),
                ),
                TextField(
                  controller: birthdateController,
                  readOnly: true,
                  onTap: () async {
                    final DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      birthdateController.text =
                          DateFormat('yyyy-MM-dd').format(date);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Birthdate',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteFamilyMember(index);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                editFamilyMember(index);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void addFamilyMember() {
    String name = nameController.text;
    String relation = relationController.text;
    String birthdate = birthdateController.text;

    if (name.isNotEmpty && relation.isNotEmpty && birthdate.isNotEmpty) {
      Map<String, dynamic> member = {
        'Name': name,
        'Relation': relation,
        'Birthdate': birthdate,
      };

      setState(() {
        familyMembers.add(member);
        saveFamilyMembers();
        nameController.clear();
        relationController.clear();
        birthdateController.clear();
      });
    }
  }

  void deleteFamilyMember(int index) {
    setState(() {
      familyMembers.removeAt(index);
      saveFamilyMembers();
      nameController.clear();
      relationController.clear();
      birthdateController.clear();
    });
  }

  void editFamilyMember(int index) {
    String name = nameController.text;
    String relation = relationController.text;
    String birthdate = birthdateController.text;

    if (name.isNotEmpty && relation.isNotEmpty && birthdate.isNotEmpty) {
      Map<String, dynamic> editedMember = {
        'Name': name,
        'Relation': relation,
        'Birthdate': birthdate,
      };

      setState(() {
        familyMembers[index] = editedMember;
        saveFamilyMembers();
        nameController.clear();
        relationController.clear();
        birthdateController.clear();
      });
    }
  }

  Future<void> showMemberDetailsDialog(Map<String, dynamic> member) async {
    DateTime birthdate = DateFormat('yyyy-MM-dd').parse(member['Birthdate']);
    DateTime today = DateTime.now();
    int years = today.year - birthdate.year;
    int months = today.month - birthdate.month;
    int days = today.day - birthdate.day;

    if (months < 0 || (months == 0 && days < 0)) {
      years--;
      months += 12;
    }

    DateTime nextBirthday =
        DateTime(today.year, birthdate.month, birthdate.day);
    if (today.isAfter(nextBirthday)) {
      nextBirthday = DateTime(today.year + 1, birthdate.month, birthdate.day);
    }

    int daysUntilNextBirthday = nextBirthday.difference(today).inDays;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Details for ${member['Name']}'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: ${member['Name']}'),
              Text('Relation: ${member['Relation']}'),
              Text('Birthdate: ${member['Birthdate']}'),
              Text('Age: $years years $months months $days days'),
              Text(
                  'Next Birthday: ${DateFormat('MMMM dd').format(nextBirthday)}'),
              Text('$daysUntilNextBirthday days until the next birthday'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Members'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              showAddMemberDialog();
            },
            child: const Text('Add Family Member'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: familyMembers.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('${familyMembers[index]['Name']}'),
                    subtitle: Text(
                        'Relation: ${familyMembers[index]['Relation']} | Birthdate: ${familyMembers[index]['Birthdate']}'),
                    onTap: () {
                      showMemberDetailsDialog(familyMembers[index]);
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showEditMemberDialog(index);
                      },
                    ),
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
