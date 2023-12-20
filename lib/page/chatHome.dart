import 'package:chatapp/page/conversationList.dart';
import 'package:flutter/material.dart';

import '../model/ChatUsers.dart';

class Chathome extends StatefulWidget {
  const Chathome({super.key});

  @override
  State<Chathome> createState() => _ChathomeState();
}

class _ChathomeState extends State<Chathome> {
  List<ChatUsers> chatUsers = [
    ChatUsers("Jane Russel", "Awesome Setup",
        "https://i.ibb.co/C9S88rZ/logo.png", "Now"),
    ChatUsers("Randika", "hi", "https://randomuser.me/api/portraits/men/5.jpg",
        "24 Feb")
  ];
  List<ChatUsers> FoundUser = [];

  @override
  void initState() {
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
            const SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Shop List",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 3, 150, 173),
                      ),
                    ),
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
                    color:const Color.fromARGB(255, 20, 20, 20)
                        .withOpacity(0.17), 
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
                        name: FoundUser[index].name,
                        messageText: FoundUser[index].messageText,
                        imageUrl: FoundUser[index].imageURL,
                        time: FoundUser[index].time,
                        isMessageRead: false,
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
          ],
        ),
      ),
    );
  }
}
