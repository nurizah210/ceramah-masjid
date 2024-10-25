import 'package:ceramahmasjidfinal/views/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:ceramahmasjidfinal/myserverconfig.dart';
import 'package:ceramahmasjidfinal/model/ceramah.dart';

class ManageCeramah extends StatefulWidget {
  @override
  _ManageCeramahState createState() => _ManageCeramahState();
}

class _ManageCeramahState extends State<ManageCeramah> {
  String? _selectedMasjid;
  List<Ceramah> _ceramahList = [];

  final List<String> _masjidList = [
    'Masjid Sultan Badlishah UUM',
    'Masjid Imam Syafie Bukit Kachi',
    'Masjid Ihya Ulumuddin Pekan Changlun',
    'Masjid Al Ihsan Kampung Changkat Setul',
    'Masjid Jame Al Hidayah'
  ];

  void _fetchCeramahs(String masjid) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${MyServerConfig.server}/ceramahmasjidfinal/php/get_ceramah.php?masjid=$masjid'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success') {
          List<dynamic> ceramahData = data['data'];
          List<Ceramah> ceramahs =
              ceramahData.map((item) => Ceramah.fromJson(item)).toList();
          setState(() {
            _ceramahList = ceramahs;
          });
        } else {
          setState(() {
            _ceramahList = [];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Please add new ceramah'),
                backgroundColor: Color.fromARGB(255, 142, 128, 91)),
          );
        }
      } else {
        throw Exception('Failed to load ceramah');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _deleteCeramah(int id) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${MyServerConfig.server}/ceramahmasjidfinal/php/delete_ceramah.php'),
        body: {'id': id.toString()},
      );

      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        setState(() {
          _ceramahList.removeWhere((ceramah) => ceramah.id == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Ceramah deleted successfully'),
              backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to delete ceramah'),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to delete ceramah: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  void _logout() async {
    bool confirmLogout = await _showLogoutConfirmationDialog();
    if (confirmLogout) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    }
  }
Future<bool> _showLogoutConfirmationDialog() async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Color.fromARGB(226, 225, 206, 186),

      title: const Text('Confirm Logout'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 144, 128, 111), // Button color
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 144, 128, 111), // Button color
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    ),
  ) ?? false;
}



  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) {
      return 'No date';
    }
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('dd/MM/yy').format(date);
  }

  String _formatTime(String timeStr) {
    if (timeStr.isEmpty) {
      return 'No time';
    }
    DateTime time = DateFormat('HH:mm').parse(timeStr);
    return DateFormat('HH:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Ceramah'),
        backgroundColor: Color.fromARGB(255, 144, 128, 111),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          color: Colors.white,
          onPressed: _logout,
        ),
        actions: [
          if (_selectedMasjid != null)
            IconButton(
              icon: const Icon(Icons.add),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddCeramahPage(masjid: _selectedMasjid!),
                  ),
                ).then((_) {
                  // Refresh the ceramah list when returning from the AddCeramahPage
                  if (_selectedMasjid != null) {
                    _fetchCeramahs(_selectedMasjid!);
                  }
                });
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Select Masjid',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 144, 128, 111)),
            ),
            DropdownButtonFormField<String>(
              value: _selectedMasjid,
              items: _masjidList.map((masjid) {
                return DropdownMenuItem(
                  value: masjid,
                  child: Text(masjid),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMasjid = value;
                  if (value != null) {
                    _fetchCeramahs(value);
                  }
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder( // Use OutlineInputBorder instead of UnderlineInputBorder
      borderSide: BorderSide(color: Color.fromARGB(255, 147, 123, 99)), // Specify border color
       // Specify border radius if needed
    ),
              ),
              validator: (value) =>
                  value == null ? 'Please select a masjid' : null,
            ),
            const SizedBox(height: 20),
            if (_selectedMasjid != null) ...[
              const Text(
                'Swipe left on a ceramah to delete it.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _ceramahList.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        _deleteCeramah(_ceramahList[index].id);
                      },
                      child:Card(
  color: Color.fromARGB(255, 144, 128, 111),
  elevation: 2,
  margin: const EdgeInsets.symmetric(vertical: 5),
  child: ListTile(
    title: Text(
      _ceramahList[index].title,
      style: const TextStyle(color: Colors.white),
    ),
    subtitle: Text(
      '${_formatDate(_ceramahList[index].date)} ${_formatTime(_ceramahList[index].time)}',
      style: const TextStyle(color: Colors.white),
    ),
    trailing: Text(
      _ceramahList[index].speaker,
      style: const TextStyle(color: Colors.white),
    ),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditCeramahPage(ceramah: _ceramahList[index]),
        ),
      ).then((_) {
        // Refresh the ceramah list when returning from the EditCeramahPage
        if (_selectedMasjid != null) {
          _fetchCeramahs(_selectedMasjid!);
        }
      });
    },
  ),
),

                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AddCeramahPage extends StatefulWidget {
  final String masjid;

  AddCeramahPage({required this.masjid});

  @override
  _AddCeramahPageState createState() => _AddCeramahPageState();
}

class _AddCeramahPageState extends State<AddCeramahPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _speakerController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse(
            '${MyServerConfig.server}/ceramahmasjidfinal/php/add_ceramah.php'),
        body: {
          'masjid': widget.masjid,
          'title': _titleController.text,
          'date': _dateController.text,
          'time': _timeController.text,
          'speaker': _speakerController.text,
        },
      );

      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Ceramah added successfully'),
              backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to add ceramah'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final selectedTime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      setState(() {
        _timeController.text = DateFormat('HH:mm').format(selectedTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Ceramah'),
        backgroundColor: Color.fromARGB(255, 144, 128, 111),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date'),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) =>
                    value!.isEmpty ? 'Please select a date' : null,
              ),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time'),
                readOnly: true,
                onTap: () => _selectTime(context),
                validator: (value) =>
                    value!.isEmpty ? 'Please select a time' : null,
              ),
              TextFormField(
                controller: _speakerController,
                decoration: const InputDecoration(labelText: 'Speaker'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the speaker\'s name' : null,
              ),
              const SizedBox(height: 20),
              Center(child: ElevatedButton(
                onPressed: _submitForm,
                 style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 144, 128, 111)
                  
                 ), child : Text('Add Ceramah'),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class EditCeramahPage extends StatefulWidget {
  final Ceramah ceramah;

  EditCeramahPage({required this.ceramah});

  @override
  _EditCeramahPageState createState() => _EditCeramahPageState();
}

class _EditCeramahPageState extends State<EditCeramahPage> {
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _titleController;
  late TextEditingController _speakerController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.ceramah.date);
    _timeController = TextEditingController(text: widget.ceramah.time);
    _titleController = TextEditingController(text: widget.ceramah.title);
    _speakerController = TextEditingController(text: widget.ceramah.speaker);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse(
            '${MyServerConfig.server}/ceramahmasjidfinal/php/update_ceramah.php'),
        body: {
          'id': widget.ceramah.id.toString(),
          'title': _titleController.text,
          'date': _dateController.text,
          'time': _timeController.text,
          'speaker': _speakerController.text,
        },
      );

      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Ceramah updated successfully'),
              backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to update ceramah'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final selectedTime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      setState(() {
        _timeController.text = DateFormat('HH:mm').format(selectedTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Ceramah'),
        backgroundColor: Color.fromARGB(255, 144, 128, 111),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date'),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) =>
                    value!.isEmpty ? 'Please select a date' : null,
              ),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time'),
                readOnly: true,
                onTap: () => _selectTime(context),
                validator: (value) =>
                    value!.isEmpty ? 'Please select a time' : null,
              ),
              TextFormField(
                controller: _speakerController,
                decoration: const InputDecoration(labelText: 'Speaker'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the speaker\'s name' : null,
              ),
              const SizedBox(height: 20),
              Center(child: ElevatedButton(
                onPressed: _submitForm,
                 style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 144, 128, 111)
                 ),child: const Text('Update Ceramah'),

               ) ),
            ],
          ),
        ),
      ),
    );
  }
}
