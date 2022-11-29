import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:uuid/uuid.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:http/http.dart';
import 'dart:convert';




class VideoCallScreen extends StatefulWidget {

  String channelName = "";

   VideoCallScreen({required this.channelName});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {

  String tempToken = "";

  late final AgoraClient _client;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    String link = "https://agora-node-tokenserver.vishallad.repl.co/access_token?channelName=${widget.channelName}";
    Response _response = await get(Uri.parse(link));
    Map data = jsonDecode(_response.body);
    setState(() {
      tempToken = data["token"];
    });
    _client = AgoraClient(agoraConnectionData: AgoraConnectionData(
        appId: "3df76ce332a14602a901bd41e020bdd8",
        tempToken: tempToken,
        channelName: widget.channelName
    ), enabledPermission: [Permission.camera,Permission.microphone]
    );

    await _client.initialize();
}


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar:  AppBar(
          title:Text('video call'),
      ),
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(client: _client,
              layoutType: Layout.floating,
                showNumberOfUsers: true,
              ),
              AgoraVideoButtons(client: _client,
              enabledButtons: const[
                BuiltInButtons.toggleCamera,
                BuiltInButtons.callEnd,
                BuiltInButtons.toggleMic,
                BuiltInButtons.switchCamera
                ],)
            ],
          ),
        ),
      ),
    );
  }
}
