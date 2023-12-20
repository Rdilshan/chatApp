// ignore_for_file: file_names

import 'package:chatapp/page/chatDetailPage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ConversationList extends StatefulWidget {

  String name;
  String messageText;
  String imageUrl;
  String time;
  bool isMessageRead;
  ConversationList({super.key, required this.name,required this.messageText,required this.imageUrl,required this.time,required this.isMessageRead});
  
  @override
  State<ConversationList> createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {



  @override
  Widget build(BuildContext context) {

   return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return const ChatDetailPage();
        }));
      },
      child: Container(
        color: Color.fromARGB(255, 248, 248, 248),
        padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
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
                      )
                 ,const SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.name, style: const TextStyle(fontSize: 16),),
                          const SizedBox(height: 6,),
                          Text(widget.messageText,
                          style: TextStyle(
                            fontSize: 13,
                            color: widget.isMessageRead? Colors.grey.shade600:Colors.blue,
                             fontWeight:FontWeight.normal),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.time,style: TextStyle(fontSize: 12,fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
          ],
        ),
      ),
    );
  }
}