import 'package:chatapp/page/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: EasySplashScreen(
      logo:const Image(image: AssetImage("assets/images/logo.png")),
      title: const Text(
        "Title",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.grey.shade400,
      showLoader: true,
      // ignore: unnecessary_const
      loadingText: const Text("Loading..."),
      navigator:const LoginScreen(),
      durationInSeconds: 5,
    ));
  }
}
