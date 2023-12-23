import 'dart:convert';

import 'package:chatapp/model/ChatMessage.dart';
import 'package:chatapp/page/chatHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: must_be_immutable
class ChatDetailPage extends StatefulWidget {
  late String name;
  late String profileimg;
  late String shopid;
  late String recieverID;
  late String clamCoin;

  ChatDetailPage({Key? key,
  required this.shopid,
  required this.recieverID,
   required this.name,
    required this.profileimg,
     required this.clamCoin
    }): super(key: key);

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {

  bool isLoading = false;
  List<ChatMessage> messages = [];

  // List<ChatMessage> messages = [
  //   ChatMessage(
  //       messageContent: "Hello, Will",
  //       messageType: "1",
  //       mesMsg: "https://randomuser.me/api/portraits/men/5.jpg"),
  //   ChatMessage(
  //       messageContent: "How have you been?",
  //       messageType: "0",
  //       mesMsg: "https://randomuser.me/api/portraits/men/5.jpg"),
  // ];
  void loadchats() async {

       var url = Uri.https(
      'asiald.lk', '/internal-projects/pos/FormobileAPK/getchat.php');
      var response = await http.post(url,
          body: {'shopID': widget.shopid, 'recieverID': widget.recieverID});
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      // Assuming jsonResponse is a list (JSON array)
      for (var entry in jsonResponse) {
        String messageContent = entry["messageContent"];
        String messageType = entry["messageType"];
        String mesMsg = entry["mesMsg"];

        ChatMessage newChatMessage = ChatMessage(messageContent: messageContent, messageType: messageType, mesMsg: mesMsg);

        setState(() {
          messages.add(newChatMessage);
          isLoading=false;
        });
      }
    }



  }


  @override
  void initState() {
     setState(() {
          isLoading=true;
      });
    loadchats();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(103, 46, 125, 181),
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      Navigator.push(context,MaterialPageRoute(builder: (_) => const Chathome()));
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.profileimg),
                    maxRadius: 20,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                  
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 246, 201, 0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child:  Text(
                        widget.clamCoin,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  
                  
                  
                ],
              ),
            ),
          ),
        ),
        body: Stack(children: <Widget>[
          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoading
                      ? LoadingAnimationWidget.prograssiveDots(
                          color: Color.fromARGB(255, 4, 155, 178),
                          size: 80,
                        )
                      : SizedBox(),
                  SizedBox(height:16), // Optional spacing between the loading widget and other content
                  // Your other content/widgets go here
                ],
              ),
            ),
          ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 193, 239, 246),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (messages[index].messageType == "1")
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network('https://asiald.lk/internal-projects/pos2/images/ads/${messages[index].mesMsg}',
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        Text(
                          messages[index].messageContent,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ]));
  }
}
