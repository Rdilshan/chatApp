// ignore_for_file: file_names

import 'package:chatapp/page/chatDetailPage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ConversationList extends StatefulWidget {
  String shopid;
  String recieverID;
  String name;
  String messageText;
  String imageUrl;
  String time;
  bool isMessageRead;
  String clamCoin;
  String hasnotreadvalue;
  ConversationList( 
      {super.key,
      required this.shopid,
      required this.recieverID,
      required this.name,
      required this.messageText,
      required this.imageUrl,
      required this.time,
      required this.isMessageRead,
      required this.clamCoin,
      required this.hasnotreadvalue});

  @override
  State<ConversationList> createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {

  bool hasnotreadvaluecheck = false;

  @override
  void initState() {
    if(widget.hasnotreadvalue != '0'){
      setState(() {
        hasnotreadvaluecheck = true;
      });
      
    }
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatDetailPage(
            name: widget.name,
            recieverID: widget.recieverID,
            profileimg: widget.imageUrl,
            shopid: widget.shopid,
            clamCoin: widget.clamCoin,
          );
        }));
      },
      child: Container(
        color: Color.fromARGB(255, 248, 248, 248),
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        margin: EdgeInsets.all(3),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.imageUrl),
                    backgroundColor: Colors.transparent,
                    maxRadius: 30,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.messageText,
                            style: TextStyle(
                                fontSize: 13,
                                color: widget.isMessageRead
                                    ? Colors.grey.shade600
                                    : Colors.blue,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if(hasnotreadvaluecheck)
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 228, 8),
                borderRadius:BorderRadius.circular(50), 
              ),
              padding: EdgeInsets.all(7), 
              child: const Text(
                "1",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),fontSize: 10, fontWeight: FontWeight.bold,),),
            ),
            const SizedBox(width: 15),
            Text(
              widget.time,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: widget.isMessageRead
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}

