import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/web/rtc_session_description.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:pytch/services/db_event.dart';
import 'package:provider/provider.dart';
// AG
import 'package:uuid/uuid.dart';
// AG

class Broadcast extends StatefulWidget {
  Broadcast({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BroadcastState createState() => _BroadcastState();
}

class _BroadcastState extends State<Broadcast> {

  bool _offer = false;
  RTCPeerConnection _peerConnection;
  MediaStream _localStream;
  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
  //RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();

  final sdpController = TextEditingController();

  @override
  dispose() {
    _localRenderer.dispose();
   // _remoteRenderer.dispose();
    sdpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initRenderers();
    // _createPeerConnection().then((pc) {
    //   _peerConnection = pc;
    // });
    super.initState();
  }

  initRenderers() async {
    await _localRenderer.initialize();
    //await _remoteRenderer.initialize();
  }
  void _openMedia() async{
    _createPeerConnection().then((pc) {
      _peerConnection = pc;
    });
  }
  
  void _createOffer() async {
    // AG
    var uuid = Uuid();
    var eventid = uuid.v4();
    // AG
    RTCSessionDescription description =
       // await _peerConnection.createOffer({'offerToReceiveAudio': 0,'offerToReceiveVideo': 0});
        await _peerConnection.createOffer({'offerToReceiveVideo': 1});
 var session = parse(description.sdp);
    print(json.encode(session));
    _offer = true;

    // print(json.encode({
    //       'sdp': description.sdp.toString(),
    //       'type': description.type.toString(),
    //     }));

    _peerConnection.setLocalDescription(description);
    // AG
    print(eventid);
    DbEventService(uid: eventid).createEventData('Manly round 5', '1234');
    DbEventService(uid: eventid).updateEventoffer(description.type, json.encode(session));
    print('herrrrrrrrrrrrrrrrre');


       DbEventService(uid: eventid).eventData.listen((event) {
        print('event');
         print(event);
         print('answer');
         print(event.answer);
         print('Value from controller: event');
         print('candidate');
         print(event.candidate);

         if (event.answer.isNotEmpty )
         {
           sdpController.text = event.answer;
           _setRemoteDescription();
         }

         if (event.candidate.isNotEmpty )
         {
           sdpController.text = event.candidate;
           _addCandidate();
         }

         
         //.toString();

       });

    // AG
  }

  void _createAnswer() async {
    RTCSessionDescription description =
        //await _peerConnection.createAnswer({'offerToReceiveVideo': 1});
        //await _peerConnection.createAnswer({'offerToReceiveAudio': 0,'offerToReceiveVideo': 1});
        await _peerConnection.createAnswer({'offerToReceiveVideo': 1});


    var session = parse(description.sdp);
    print(json.encode(session));
    // print(json.encode({
    //       'sdp': description.sdp.toString(),
    //       'type': description.type.toString(),
    //     }));

    _peerConnection.setLocalDescription(description);
  }

  void _setRemoteDescription() async {
    String jsonString = sdpController.text;
    dynamic session = await jsonDecode('$jsonString');

    String sdp = write(session, null);

    // RTCSessionDescription description =
    //     new RTCSessionDescription(session['sdp'], session['type']);
    RTCSessionDescription description =
        new RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');
    print(description.toMap());

    await _peerConnection.setRemoteDescription(description);
  }

  void _addCandidate() async {
    String jsonString = sdpController.text;
    dynamic session = await jsonDecode('$jsonString');
    print(session['candidate']);
    dynamic candidate =
        new RTCIceCandidate(session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
    await _peerConnection.addCandidate(candidate);
  }

  _createPeerConnection() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };

    _localStream = await _getUserMedia();

    RTCPeerConnection pc = await createPeerConnection(configuration, offerSdpConstraints);
    // if (pc != null) print(pc);
    pc.addStream(_localStream);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        print(json.encode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMlineIndex,
        }));
      }
    };

    pc.onIceConnectionState = (e) {
      print(e);
    };

    pc.onAddStream = (stream) {
      print('addStream: ' + stream.id);
      //_remoteRenderer.srcObject = stream;
    };

    return pc;
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': false,
      'video': {
        'facingMode': 'user',
      },
    };

    MediaStream stream = await navigator.getUserMedia(mediaConstraints);

    // _localStream = stream;
    _localRenderer.srcObject = stream;
    _localRenderer.mirror = true;

    // _peerConnection.addStream(stream);

    return stream;
  }

  SizedBox videoRenderers() => SizedBox(
      height: 210,
      child: Row(children: [
        Flexible(
          child: new Container(
            key: new Key("local"),
            margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
            decoration: new BoxDecoration(color: Colors.black),
            child: new RTCVideoView(_localRenderer)
          ),
        ),
        // Flexible(
        //   child: new Container(
        //       key: new Key("remote"),
        //       margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        //       decoration: new BoxDecoration(color: Colors.black),
        //       child: new RTCVideoView(_remoteRenderer)),
        // )
      ]));

  Row openMediaButton() =>
  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget> [
          new RaisedButton(onPressed: _openMedia,
                             child: Text('Audio On'), 
                            color: Colors.amber,
                             //style: TextButton.styleFrom(primary: Colors.green),
          )
  ]
  );

  Row offerAndAnswerButtons() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        new RaisedButton(
          // onPressed: () {
          //   return showDialog(
          //       context: context,
          //       builder: (context) {
          //         return AlertDialog(
          //           content: Text(sdpController.text),
          //         );
          //       });
          // },
          onPressed: _createOffer,
          child: Text('Broadcast'),
          color: Colors.amber,
          ),
        // RaisedButton(
        //   onPressed: _createAnswer,
        //   child: Text('Answer'),
        //   color: Colors.amber,
        // ),
      ]
      );

  Row sdpCandidateButtons() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        RaisedButton(
          onPressed: _setRemoteDescription,
          child: Text('Set Remote Desc'),
          color: Colors.amber,
        ),
        RaisedButton(
          onPressed: _addCandidate,
          child: Text('Add Candidate'),
          color: Colors.amber,
        )
      ]);

  Padding sdpCandidatesTF() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: sdpController,
          keyboardType: TextInputType.multiline,
          maxLines: 4,
          maxLength: TextField.noMaxLength,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/pytch_1125-1240.png'),
              fit: BoxFit.cover,
            ),
          ),
            child: Column(children: [
          //openMediaButton(),
          videoRenderers(),
          openMediaButton(),
          offerAndAnswerButtons(),
         // sdpCandidatesTF(),
          //sdpCandidateButtons(),
        ])));
  }
}
