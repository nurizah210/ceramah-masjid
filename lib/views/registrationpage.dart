import 'package:flutter/material.dart';
import 'package:ceramahmasjidfinal/myserverconfig.dart';
import 'package:http/http.dart' as http; // Added 'as http'
import 'package:ceramahmasjidfinal/views/manageceramah.dart';
import 'package:ceramahmasjidfinal/views/mappage.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _adminCodeController = TextEditingController();
  String usertype = 'jemaah'; // Default to 'user'
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        backgroundColor: const Color.fromARGB(255, 144, 128, 111),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
             width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/bg.png",
                ),
                fit: BoxFit.cover,
              ))),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 144, 128, 111),
                    ),
                  ),
                 TextFormField(
  controller: _usernameController,
  keyboardType: TextInputType.text,
  decoration: InputDecoration(
    hintText: 'Enter your username',
    hintStyle: TextStyle(
      color: Color.fromARGB(255, 144, 128, 111).withOpacity(0.6),
    ),
    border: OutlineInputBorder( // Use OutlineInputBorder instead of UnderlineInputBorder
      borderSide: BorderSide(color: Color.fromARGB(255, 144, 128, 111)), // Specify border color
      borderRadius: BorderRadius.circular(2.0), // Specify border radius if needed
    ),
  ),
  validator: (val) => val!.isEmpty ? 'Please enter a username' : null,
  style: TextStyle(color: Color.fromARGB(255, 144, 128, 111)),
),

                  const SizedBox(height: 20),
                  Text(
                    'Phone No',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 144, 128, 111),
                    ),
                  ),
                 TextFormField(
  controller: _phoneController,
  keyboardType: TextInputType.phone,
  decoration: InputDecoration(
    hintText: 'Enter your phone number',
    hintStyle: TextStyle(
      color: Color.fromARGB(255, 144, 128, 111).withOpacity(0.6),
    ),
    border: OutlineInputBorder( // Use OutlineInputBorder instead of UnderlineInputBorder
      borderSide: BorderSide(color: Color.fromARGB(255, 144, 128, 111)), // Specify border color
      borderRadius: BorderRadius.circular(2.0), // Specify border radius if needed
    ),
  ),
  validator: (val) => val!.isEmpty ? 'Please enter your phone number' : null,
  style: TextStyle(color: Color.fromARGB(255, 144, 128, 111)),
),

                  const SizedBox(height: 20),
                  Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 144, 128, 111),
                    ),
                  ),
                  TextFormField(
  controller: _passwordController,
  obscureText: true,
  decoration: InputDecoration(
    hintText: 'Enter your password',
    hintStyle: TextStyle(
      color: Color.fromARGB(255, 144, 128, 111).withOpacity(0.6),
    ),
    border: OutlineInputBorder( // Use OutlineInputBorder instead of UnderlineInputBorder
      borderSide: BorderSide(color: Color.fromARGB(255, 144, 128, 111)), // Specify border color
      borderRadius: BorderRadius.circular(2.0), // Specify border radius if needed
    ),
  ),
  validator: (val) => val!.isEmpty ? 'Please enter a password' : null,
  style: TextStyle(color: Color.fromARGB(255, 144, 128, 111)),
),

                  const SizedBox(height: 20),
                  Text(
                    'Confirm Password',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 144, 128, 111),
                    ),
                  ),
                  TextFormField(
  controller: _confirmPasswordController,
  obscureText: true,
  decoration: InputDecoration(
    hintText: 'Confirm your password',
    hintStyle: TextStyle(
      color: Color.fromARGB(255, 144, 128, 111).withOpacity(0.6),
    ),
    border: OutlineInputBorder( // Use OutlineInputBorder instead of UnderlineInputBorder
      borderSide: BorderSide(color: Color.fromARGB(255, 144, 128, 111)), // Specify border color
      borderRadius: BorderRadius.circular(2.0), // Specify border radius if needed
    ),
  ),
  validator: (val) {
    if (val!.isEmpty) {
      return 'Please confirm your password';
    } else if (val != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  },
  style: TextStyle(color: Color.fromARGB(255, 144, 128, 111)),
),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Radio(
                        value: 'jemaah',
                        groupValue: usertype,
                        onChanged: (value) {
                          setState(() {
                            usertype = value as String;
                          });
                        },
                        activeColor: Color.fromARGB(255, 144, 128, 111),
                      ),
                      Text(
                        'Jemaah',
                        style: TextStyle(color: Color.fromARGB(255, 144, 128, 111)),
                      ),
                      Radio(
                        value: 'masjid_admin',
                        groupValue: usertype,
                        onChanged: (value) {
                          setState(() {
                            usertype = value as String;
                          });
                        },
                        activeColor: Color.fromARGB(255, 144, 128, 111),
                      ),
                      Text(
                        'Masjid Admin',
                        style: TextStyle(color: Color.fromARGB(255, 144, 128, 111)),
                      ),
                    ],
                  ),
                  if (usertype == 'masjid_admin') ...[
                    const SizedBox(height: 20),
                    Text(
                      'Admin Code',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 144, 128, 111),
                      ),
                    ),
                    TextFormField(
                      controller: _adminCodeController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter admin code',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 144, 128, 111).withOpacity(0.6),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 144, 128, 111)),
                        ),
                      ),
                      validator: (val) {
                        if (usertype == 'masjid_admin' && val != 'ni0210') {
                          return 'Invalid admin code';
                        }
                        return null;
                      },
                      style: TextStyle(color: Color.fromARGB(255, 144, 128, 111)),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 144, 128, 111),
                      ),
                      child: const Text('Register'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _registerUser() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    final response = await http.post(
      Uri.parse("${MyServerConfig.server}/ceramahmasjidfinal/php/register_user.php"),
      body: {
        'username': _usernameController.text,
        'phone': _phoneController.text,
        'password': _passwordController.text,
        'usertype': usertype,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Success'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to different pages based on the value of usertype
      if (usertype == 'masjid_admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ManageCeramah()), // Navigate to ManageCeramah page
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MapPage()), // Navigate to MapPage
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
