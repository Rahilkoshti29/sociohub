import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController flatController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // LOAD DATA
  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userString = prefs.getString('user_data');

    if (userString != null) {
      Map<String, dynamic> userData = jsonDecode(userString);

      nameController.text = userData['name'];
      flatController.text = userData['flat'];
      mobileController.text = userData['mobile'];
      emailController.text = userData['email'];

      setState(() {});
    }
  }

  // SAVE DATA
  Future<void> saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userString = prefs.getString('user_data');

    if (userString != null) {
      Map<String, dynamic> oldData = jsonDecode(userString);

      Map<String, dynamic> updatedData = {
        "name": nameController.text,
        "flat": flatController.text,
        "mobile": mobileController.text,
        "email": emailController.text,
        "password": oldData["password"],
      };

      await prefs.setString('user_data', jsonEncode(updatedData));

      setState(() {
        isEditing = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Profile Updated")));

      // GO BACK TO HOME
      Navigator.pop(context);
    }
  }

  // LOGOUT FUNCTION
  Future<void> logoutUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),

          title: const Text("Logout"),

          content: const Text("Are you sure you want to logout?"),

          actions: [
            // CANCEL
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
            ),

            // LOGOUT
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                await prefs.remove('user_data');

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffE23744),
              ),
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        cursorColor: Colors.grey,
        controller: controller,
        enabled: isEditing,
        decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.grey),
          floatingLabelStyle: const TextStyle(color: Colors.grey),
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xffE23744), width: 2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color(0xffE23744),

        // BACK FIX
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // profile opened via push, so pop is fine
          },
        ),

        title: const Text("Profile", style: TextStyle(color: Colors.white)),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 45,
              backgroundColor: Color(0xffE23744),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),

            const SizedBox(height: 25),

            buildField("Full Name", nameController),
            buildField("Flat Number", flatController),
            buildField("Mobile Number", mobileController),
            buildField("Email", emailController),

            const SizedBox(height: 20),

            // EDIT BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (isEditing) {
                    saveUserData();
                  } else {
                    setState(() {
                      isEditing = true;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffE23744),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  isEditing ? "Save Changes" : "Edit Profile",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: logoutUser,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
