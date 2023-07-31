

import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_indicator/progress_indicator.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedinuser;

class ChatScreen extends StatefulWidget {
  @override
  static const String id = 'chatscreen';
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  final _auth= FirebaseAuth.instance;
  final messageTextcontroller = TextEditingController();

  String message = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();

  }

  void getUser() async{
    print("waiting");
    final user = await _auth.currentUser;
    try{
      if(user!=null){
        loggedinuser = user;
        print("user got");
        print(loggedinuser.email);
      }
    }
    catch(e){
      print(e);
    }
  }
  void getmessage() async{
   await for (var snapshot in  _firestore.collection('messages').snapshots()) {
     for(var message in snapshot.docs){
       print(message.data());
     }
   }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.popAndPushNamed(context, WelcomeScreen.id);

              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              messageStream(),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        controller: messageTextcontroller,
                        onChanged: (value) {
                          message=value;

                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        messageTextcontroller.clear();
                        _firestore.collection('messages').add({
                          'text':message,
                          'sender': loggedinuser.email,
                          'time': FieldValue.serverTimestamp(),
                        });
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class messageStream extends StatelessWidget {
  const messageStream({Key? key}) : super(key: key);

  @override
   Widget build(BuildContext context)  {
    return StreamBuilder<QuerySnapshot>(stream: _firestore.collection('messages').orderBy('time',descending: false).snapshots(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final messages = snapshot.data!.docs.reversed;
          List <MessageBubble> WidgetBuilder =[];
          for( var message in messages){
            final messageText= message['text'];
            final messageSender = message['sender'];
            final messageTime = message['time'] as Timestamp;

            final MessageBubbler = MessageBubble(txt: messageText, sender: messageSender,isMe:loggedinuser.email==messageSender,time:messageTime);
            WidgetBuilder.add(MessageBubbler);

          }

          return Expanded(
            child: ListView(
               reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
                children: WidgetBuilder),
          );

        }
    );
  }
}



class MessageBubble extends StatelessWidget {
  MessageBubble({required this.txt,required this.sender,required this.isMe,required this.time});
  @override

  final String txt;
  final String sender;
  bool isMe;
  final Timestamp time;
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text('${sender} ${DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000)}',style: TextStyle(
            color: Colors.black54,
            fontSize: 12.0,
          ),),
          Material(
            elevation: 5.0,
             borderRadius: isMe?BorderRadius.only(topLeft:Radius.circular(30.0),bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0)):BorderRadius.only(topRight:Radius.circular(30.0),bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0)),
             color: isMe? Colors.lightBlueAccent: Colors.white,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
                child: Text('$txt',
                style: TextStyle(
                  color: isMe? Colors.white: Colors.black54,
                  fontSize: 15.0,
                ),),
              )),
        ],
      ),
    );
   ;
  }
}
