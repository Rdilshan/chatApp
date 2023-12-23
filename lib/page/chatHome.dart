import 'dart:convert';

import 'package:chatapp/page/LoginScreen.dart';
import 'package:chatapp/page/conversationList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/ChatUsers.dart';
import 'package:http/http.dart' as http;

class Chathome extends StatefulWidget {
  const Chathome({super.key});

  @override
  State<Chathome> createState() => _ChathomeState();
}

class _ChathomeState extends State<Chathome> {
  String? idnumber;
  String? mobilenumber;

  // List<ChatUsers> chatUsers = [
  //   ChatUsers("Jane Russel", "Awesome Setup","https://i.ibb.co/C9S88rZ/logo.png", "Now"),
  //   ChatUsers("Randika", "hi", "https://randomuser.me/api/portraits/men/5.jpg",
  //       "24 Feb")
  // ];

  List<ChatUsers> chatUsers = [];
  List<ChatUsers> FoundUser = [];

  void loadSessionData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    idnumber = prefs.getString('idnumber');
    mobilenumber = prefs.getString('mobilenumber');
    getChatDetails();
  }

  Future<void> getChatDetails() async {
    var url = Uri.https(
        'asiald.lk', '/internal-projects/pos/FormobileAPK/getshopcchat.php');
    var response = await http
        .post(url, body: {'idnumber': idnumber, 'mobilenumber': mobilenumber});

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      // Assuming jsonResponse is a list (JSON array)
      for (var entry in jsonResponse) {
        String shopid = entry["id"];
        String recieverID = entry["recieverID"];
        String name = entry["name"];
        String messageText = entry["messageText"];
        String imageURL = entry["imageURL"];
        String time = entry["time"];
        String clamCoin = entry["clamCoin"];
        String hasnotreadvalue = entry["hasnotreadvalue"];

        ChatUsers newChatUser = ChatUsers(
            shopid, recieverID, name, messageText, imageURL, time, clamCoin,hasnotreadvalue);

        setState(() {
          chatUsers.add(newChatUser);
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    loadSessionData();
    FoundUser = chatUsers;
    super.initState();
  }

  _runFilter(String value) {
    List<ChatUsers> resultUsers = [];
    if (value.isEmpty) {
      resultUsers = chatUsers;
    } else {
      resultUsers = chatUsers
          .where(
              (user) => user.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    setState(() {
      FoundUser = resultUsers;
    });
  }

  bool isLoading = false;
  String searchText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      "Shop List",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 3, 150, 173),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 2, bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50],
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          // Handle the click action here
                          // You can perform the logout logic or navigate to another screen
                          print("Logout clicked");
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.remove('idnumber');
                          await prefs.remove('mobilenumber');

                          // ignore: use_build_context_synchronously
                          Navigator.push(context,MaterialPageRoute(builder: (_) => const LoginScreen()));
                        },

                        child: const Row(
                          children: <Widget>[
                            Icon(Icons.add, color: Colors.pink, size: 20),
                            SizedBox(width: 2),
                            Text(
                              "Logout",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 13, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.all(8),
                  border: InputBorder.none,
                  enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
                textAlignVertical: TextAlignVertical.center,
                onChanged: (value) => _runFilter(value),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 20, 20, 20).withOpacity(0.17),
                    blurRadius: 80.0,
                    offset: const Offset(10, 10),
                  ),
                ],
              ),
              child: const Divider(
                height: 10,
                indent: 1,
                endIndent: 1,
                thickness: 1,
                color: Color.fromARGB(255, 241, 241, 241),
              ),
            ),
            FoundUser.isNotEmpty
                ? ListView.builder(
                    itemCount: FoundUser.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 16),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ConversationList(
                        shopid: FoundUser[index].shopid,
                        recieverID: FoundUser[index].recieverID,
                        name: FoundUser[index].name,
                        messageText: FoundUser[index].messageText,
                        imageUrl: FoundUser[index].imageURL,
                        time: FoundUser[index].time,
                        isMessageRead: false,
                        clamCoin: FoundUser[index].clamCoin,
                        hasnotreadvalue: FoundUser[index].hasnotreadvalue,
                      );
                    },
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 40),
                        Text(
                          'No items',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoading
                      ? LoadingAnimationWidget.prograssiveDots(
                          color: Color.fromARGB(255, 4, 155, 178),
                          size: 80,
                        )
                      : SizedBox(), // Optional spacing between the loading widget and other content
                  // Your other content/widgets go here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
