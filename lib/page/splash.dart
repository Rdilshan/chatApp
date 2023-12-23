import 'package:chatapp/page/LoginScreen.dart';
import 'package:chatapp/page/chatHome.dart';
import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  String? idnumber;
  String? mobilenumber;

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idnumber = prefs.getString('idnumber');
      mobilenumber = prefs.getString('mobilenumber');
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: EasySplashScreen(
      logo: const Image(
          image: AssetImage("assets/images/logo.png"),
          width: 400, // Set the width to your desired size
          height: 400),
      title: const Text(
        "Powered by Zion Mobility",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 4, 155, 178),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      showLoader: true,
      // ignore: unnecessary_const
      loadingText: const Text("Starting..."),
      durationInSeconds: 5,
      navigator: (idnumber != null || mobilenumber != null)
          ? const Chathome()
          : const LoginScreen(),
    ));
  }
}
