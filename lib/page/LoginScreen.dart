// ignore_for_file: file_names

import 'package:chatapp/page/chatHome.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool iscorrect = false;
  bool isLoading = false;

  final TextEditingController _idnumber = TextEditingController();
  final TextEditingController _mobilenumber = TextEditingController();


void ValidData(enteredValue, entermobilenumber, context) async {
  if (enteredValue == null || entermobilenumber == null) {
      setState(() {
        iscorrect = true;
      });
      return;
    }
 
  var url = Uri.https(
      'asiald.lk', '/internal-projects/pos/FormobileAPK/checkingLogin.php');
      var response = await http.post(url,
          body: {'idnumber': enteredValue, 'mobilenumber': entermobilenumber});
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

   if (response.body == '0') {
      // If it is '0', navigate to the Chathome screen
       setState(() {
        iscorrect = true;
         isLoading = false;
      });
      return;
    }

// Obtain shared preferences.
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('idnumber', enteredValue);
  await prefs.setString('mobilenumber', entermobilenumber);

  Navigator.push(context,MaterialPageRoute(builder: (_) => const Chathome()));
}


void loadData() async {
  // final SharedPreferences prefs = await SharedPreferences.getInstance();
  // final String? idnumber = prefs.getString('idnumber');
  // final String? mobilenumber = prefs.getString('mobilenumber');


  // if (idnumber != null || mobilenumber != null) {
  //   print('Counter value is set: $idnumber');
  //   print('Counter value is set: $mobilenumber');

  //   Navigator.push(context,MaterialPageRoute(builder: (_) => const Chathome()));
  //   // Add your logic based on the loaded data here
  // } else {
  //   print('value is not set.');
  //   // Handle the case where the counter value is not set
  //   // You may want to set a default value or perform other actions
  // }
}


@override
  void initState()  {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.2),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child:const Image(image: AssetImage("assets/images/logo.png")),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            if (iscorrect)
              const Text("Wrong Email or Password",
                  style: TextStyle(color: Colors.red)),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: TextField(
                controller: _idnumber,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: 'Id Number',
                  hintText: 'Enter valid email id as abc@gmail.com',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.015,
                    horizontal: MediaQuery.of(context).size.width * 0.03,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.015),
              child: TextField(
                controller: _mobilenumber,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: 'Mobile Number',
                  hintText: 'Enter secure password',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.015,
                    horizontal: MediaQuery.of(context).size.width * 0.03,
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 4, 155, 178),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });

                  String enteredValue = _idnumber.text;
                  var entermobilenumber = _mobilenumber.text;

                  print('Entered Value: $enteredValue');
                  print('Entered Value: $entermobilenumber');
                  ValidData(enteredValue, entermobilenumber, context);

                  // Navigator.push(context,MaterialPageRoute(builder: (_) => const Chathome()));
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Container(
              child: isLoading
                  ? LoadingAnimationWidget.prograssiveDots(
                      color: Color.fromARGB(255, 4, 155, 178),
                      size: 60,
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
