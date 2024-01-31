import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:lifechrono/components/ad_helper.dart';
import 'package:lifechrono/components/sql_helper.dart';

class AddFamilyMembers extends StatefulWidget {
  const AddFamilyMembers({super.key});

  @override
  State<AddFamilyMembers> createState() => _AddFamilyMembersState();
}

class _AddFamilyMembersState extends State<AddFamilyMembers> {
  //add
  BannerAd? _bannerAd;
  List<Map<String, dynamic>> _familyMembers = [];
  // ignore: unused_field
  bool _isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  void _refreshFamilyMembers() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _familyMembers = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshFamilyMembers();
    _create_bannerAd();
  }

  void _showAddFamilyMemberDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Family Member'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _relationController,
                  decoration: const InputDecoration(labelText: 'Relation'),
                ),
                TextField(
                  controller: _birthdateController,
                  readOnly: true,
                  onTap: () async {
                    final DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      _birthdateController.text =
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
              child: const Text('Cancel'),
              onPressed: () {
                _nameController.clear();
                _relationController.clear();
                _birthdateController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                await SQLHelper.createItem(
                  _nameController.text,
                  _relationController.text,
                  _birthdateController.text,
                );
                _refreshFamilyMembers();
                _nameController.clear();
                _relationController.clear();
                _birthdateController.clear();
                print("..number of family members: ${_familyMembers.length}");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

//edit
// edit
  void _showEditMemberDialog(int index) {
    _nameController.text = _familyMembers[index]['name'];
    _relationController.text = _familyMembers[index]['relationship'];
    _birthdateController.text = _familyMembers[index]['birthdate'];
    int id = _familyMembers[index]['id'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Family Member'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _relationController,
                  decoration: const InputDecoration(labelText: 'Relation'),
                ),
                TextField(
                  controller: _birthdateController,
                  readOnly: true,
                  onTap: () async {
                    final DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      _birthdateController.text =
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
              child: const Text('Cancel'),
              onPressed: () {
                _nameController.clear();
                _relationController.clear();
                _birthdateController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () async {
                await SQLHelper.updateItem(
                  id,
                  _nameController.text,
                  _relationController.text,
                  _birthdateController.text,
                );
                _refreshFamilyMembers();
                _nameController.clear();
                _relationController.clear();
                _birthdateController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await SQLHelper.deleteItem(id);
                _refreshFamilyMembers();
                _nameController.clear();
                _relationController.clear();
                _birthdateController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //member details
  _showMemberDetailsDialog(int index) {
    DateTime birthdate =
        DateFormat('yyyy-MM-dd').parse(_familyMembers[index]['birthdate']);
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_familyMembers[index]['name']),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Relation: ${_familyMembers[index]['relationship']}",
                ),
                Text(
                  "Birthdate: ${_familyMembers[index]['birthdate']}",
                ),
                Text('Age: $years years $months months $days days'),
                Text('Days until next birthday: $daysUntilNextBirthday days'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //add
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
          title: const Text('Add Family Members'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddFamilyMemberDialog,
          child: const Icon(Icons.add),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: _familyMembers.length,
            itemBuilder: (context, index) => Card(
              child: ListTile(
                title: Text(_familyMembers[index]['name']),
                subtitle: Text(
                  "${_familyMembers[index]['relationship']} | Birthdate: ${_familyMembers[index]['birthdate']}",
                ),
                onTap: () => _showMemberDetailsDialog(index),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditMemberDialog(index),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: _bannerAd == null
            ? Container()
            : Container(
                height: 54,
                child: AdWidget(ad: _bannerAd!),
              ));
  }
}
