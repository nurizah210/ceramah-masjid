import 'package:flutter/material.dart';
import 'package:ceramahmasjidfinal/views/ceramahdetails.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ceramahmasjidfinal/views/mainpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapPage(),
    );
  }
}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('masjid1'),
          position: LatLng(6.4620651385268095,
              100.49900713415322), // Masjid Sultan Badlishah UUM
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CeramahDetails(
                  masjid: 'Masjid Sultan Badlishah UUM',
                ),
              ),
            );
          },
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('masjid2'),
          position: LatLng(6.439997927192369,
              100.5280726664409), // Masjid Imam Syafie Bukit Kachi
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CeramahDetails(
                  masjid: 'Masjid Imam Syafie Bukit Kachi',
                ),
              ),
            );
          },
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('masjid3'),
          position: LatLng(
              6.424813138407656, 100.44795860901246), // Masjid Jame Al Hidayah
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CeramahDetails(
                  masjid: 'Masjid Jame Al Hidayah',
                ),
              ),
            );
          },
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('masjid4'),
          position: LatLng(6.422201977736041,
              100.42815131061731), // Masjid Ihya Ulumuddin Pekan Changlun
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CeramahDetails(
                  masjid: 'Masjid Ihya Ulumuddin Pekan Changlun',
                ),
              ),
            );
          },
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('masjid5'),
          position: LatLng(6.432399102334476,
              100.46055042382133), // Masjid Al Ihsan Kampung Changkat Setul
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CeramahDetails(
                  masjid: 'Masjid Al Ihsan Kampung Changkat Setul',
                ),
              ),
            );
          },
        ),
      );
    });
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Page'),
        backgroundColor: Color.fromARGB(255, 144, 128, 111),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          color: Colors.white,
          onPressed: _logout,
        ),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
            target: LatLng(6.441149619167723, 100.46510752944144), zoom: 11.5),
        markers: _markers,
      ),
    );
  }
}
