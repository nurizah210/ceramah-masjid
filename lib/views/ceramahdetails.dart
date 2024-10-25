import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:ceramahmasjidfinal/myserverconfig.dart';
import 'package:ceramahmasjidfinal/model/ceramah.dart';

class CeramahDetails extends StatefulWidget {
  final String masjid;

  CeramahDetails({required this.masjid});

  @override
  _CeramahDetailsState createState() => _CeramahDetailsState();
}

class _CeramahDetailsState extends State<CeramahDetails> {
  late Future<List<Ceramah>> _ceramahDetailsFuture;

  @override
  void initState() {
    super.initState();
    _ceramahDetailsFuture = _fetchCeramahDetails(widget.masjid);
  }

  Future<List<Ceramah>> _fetchCeramahDetails(String masjid) async {
    try {
      final response = await http.get(
        Uri.parse('${MyServerConfig.server}/ceramahmasjidfinal/php/get_ceramah.php?masjid=$masjid'),
      );
        if (!mounted) return []; 

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success') {
          List<dynamic> ceramahData = data['data'];
          List<Ceramah> ceramahs = ceramahData.map((item) => Ceramah.fromJson(item)).toList();
          return ceramahs;
        } else {
          throw ('No Ceramah found');
        }
      } else {
        throw ('No ceramah found');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  bool _isToday(DateTime date) {
    DateTime now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isPastDate(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  String _formatTime(String timeStr) {
    if (timeStr.isEmpty) {
      return 'No time';
    }
    DateTime time = DateFormat('HH:mm').parse(timeStr);
    return DateFormat('HH:mm').format(time);
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) {
      return 'No date';
    }
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('dd/MM/yy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ceramah Details'),
        backgroundColor: Color.fromARGB(255, 144, 128, 111),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: FutureBuilder<List<Ceramah>>(
              future: _ceramahDetailsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  List<Ceramah> ceramahDetails = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' ${widget.masjid}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 144, 128, 111),
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: ceramahDetails.length,
                            itemBuilder: (context, index) {
                              Ceramah ceramah = ceramahDetails[index];
                              DateTime ceramahDate = DateTime.parse(ceramah.date);
                              Color cardColor = _isToday(ceramahDate)
                                  ? Color.fromARGB(255, 73, 95, 54)
                                  : (_isPastDate(ceramahDate) ? Colors.grey : Color.fromARGB(255, 144, 128, 111));
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 7.0),
                                elevation: 3,
                                color: cardColor,
                                child: ListTile(
                                  title: Text(
                                    ceramah.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 6),
                                      Text(
                                        'Speaker: ${ceramah.speaker}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        'Date: ${_formatDate(ceramah.date)}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        'Time: ${_formatTime(ceramah.time)}', // Use formatted time
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  isThreeLine: true,
                                  contentPadding: EdgeInsets.all(14.0),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
