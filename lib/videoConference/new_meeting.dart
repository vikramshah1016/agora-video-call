import 'package:agora_video_call/video_call.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:uuid/uuid.dart';

// import '../call_page.dart';

class NewMeeting extends StatefulWidget {
   NewMeeting({Key? key}) : super(key: key);

  @override
  State<NewMeeting> createState() => _NewMeetingState();
}

class _NewMeetingState extends State<NewMeeting> {
  String _meetingCode = "";

  @override
  void initState(){
    var uuid = Uuid();
    _meetingCode = uuid.v1().substring(0,8);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                child: Icon(Icons.arrow_back_ios_new_sharp,size: 35),
                onTap: Get.back,
              ),
            ),
            SizedBox(height: 40),
            Image.network(
              "https://user-images.githubusercontent.com/67534990/127776392-8ef4de2d-2fd8-4b5a-b98b-ea343b19c03e.png",
              fit: BoxFit.cover,
              height: 100,

            ),
            SizedBox(height: 20),
            Text("Enter meeting code below", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            Padding(padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
            child:Card(
              color: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
              ),
              child: ListTile(
                leading: Icon(Icons.link),
                title: SelectableText(
                  _meetingCode,
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                trailing: Icon(Icons.copy),
              ),
            ) ,
            ),
            Divider(thickness: 1, height: 40, indent: 20,endIndent: 20),
            ElevatedButton.icon(onPressed: (){
              Share.share("Meeting Code : $_meetingCode");
            }, icon: Icon(Icons.arrow_drop_down), label: Text("Share Invite"),
            style: ElevatedButton.styleFrom(
              fixedSize: Size(350, 30),
              primary: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
              )
            ),
            ),
            OutlinedButton.icon(onPressed: (){
              Get.to(VideoCallScreen(channelName:_meetingCode.trim()));
            },
                icon: Icon(Icons.margin), label: Text("Join with a code"),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.indigo),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
              ),
              fixedSize: Size(350, 30)
            ),
            )
            // Padding(padding: const EdgeInsets.fromLTRB(15, 20, 15, 20))
            // ElevatedButton.icon(onPressed: (){}, icon: icon, label: label)
          ],
        ),
      ),
    );
  }
}
