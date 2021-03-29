import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:flutter_webrtc/flutter_webrtc.dart';
//import 'package:sdp_transform/sdp_transform.dart';
//import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc/webrtc.dart';
//import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';
// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pytch/services/db_event.dart';
import 'package:uuid/uuid.dart';


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
  RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();

  final sdpController = TextEditingController();

  @override
  dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    sdpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initRenderers();
    _createPeerConnection().then((pc) {
      _peerConnection = pc;
    });
    super.initState();
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  void _createEvent() async {
    var uuid = Uuid();
    var eventid = uuid.v4();
    //CollectionReference events = Firestore.instance.collection('event')    ;

    RTCSessionDescription description =
        await _peerConnection.createOffer({'offerToReceiveVideo': 1});
    var session = parse(description.sdp);
    print(json.encode(session));
    _offer = true;

    // print(json.encode({
    //       'sdp': description.sdp.toString(),
    //       'type': description.type.toString(),
    //     }));

    // _offer String = 
    //       'offer': {
    //         'type': description.type,
    //         'sdp':  description.sdp
    //         }
    //     })

    _peerConnection.setLocalDescription(description);
    //DbEventService(uid: eventid).createEventData('Manly round 3', 'offer', 'answer');
    DbEventService(uid: eventid).createEventData('Manly round 3', '1234');
    DbEventService(uid: eventid).updateEventoffer(description.type, json.encode(session));
    print('******************************');
    print(eventid);
    print('******************************');
    //DbEventService(uid: null).updateEventofferData('Manly round 3', _offer, 'answer');
    // events.add({
    //   'event': 'Manly round 2',
    //   'offer': {
    //         'type': description.type,
    //         'sdp':  description.sdp
    //         }
    //     })
    //     .then((value) => print("Event Added")).
    //     catchError((error) => print("Failed to add event: $error"));

//const _eventId = events.id;
//print(events[1].event);
//#document.querySelector('#currentRoom').innerText = `Current room is ${roomId} - You are the caller!`

  }

  void _createAnswer() async {
    RTCSessionDescription description =
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
    print('000000000');

    _localStream = await _getUserMedia();
    print('111111111111');
    print(_localStream);

    RTCPeerConnection pc = await createPeerConnection(configuration, offerSdpConstraints);
    print(pc);
    print('22222222');

    // if (pc != null) print(pc);
    pc.addStream(_localStream);
    print('333333333');
    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        print(json.encode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMlineIndex,
        }));
      }
    };
    print('444444');

    pc.onIceConnectionState = (e) {
      print(e);
    };
    print('55555555');

    pc.onAddStream = (stream) {
      print('addStream: ' + stream.id);
      _remoteRenderer.srcObject = stream;
    };
    print('666666');

    return pc;
  }

  _getUserMedia() async {
    print('XXXXX');

    final Map<String, dynamic> mediaConstraints = {
      'audio': false,
      'video': {
        'facingMode': 'user',
      },
    };

    //     final Map<String, dynamic> mediaConstraints = {
    //   'audio': true,
    //   'video': false
    // };

    //var mediaConstraints = { 'audio': true, 'video': { 'width': 1280, 'height': 720 } };

    print('YYYYY');

   // MediaStream stream = await navigator.getUserMedia(mediaConstraints);
   // MediaStream stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
   MediaStream stream = await navigator.getUserMedia(mediaConstraints);
    //MediaStream stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    print('ZZZZZZ');

    // _localStream = stream;
    print(stream);
    print('AAAAA');

    _localRenderer.srcObject = stream;
   // _localRenderer.mirror = true;
    print('BBBBB');

     //_peerConnection.addStream(stream);

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
        Flexible(
          child: new Container(
              key: new Key("remote"),
              margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              decoration: new BoxDecoration(color: Colors.black),
              child: new RTCVideoView(_remoteRenderer)),
        )
      ]));

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
          onPressed: _createEvent,
          child: Text('Create Event'),
          color: Colors.amber,
        ),
        RaisedButton(
          onPressed: _createAnswer,
          child: Text('Answer'),
          color: Colors.amber,
        ),
      ]);

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
        title: Text('Broadcast'),
        //title: Text(widget.title),
      ),
      body: Container(
                 decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/pytch_1125-1240.png'),
              fit: BoxFit.cover,
            ),
          ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child:  Column(children: [
          videoRenderers(),
          offerAndAnswerButtons(),
          sdpCandidatesTF(),
          sdpCandidateButtons(),
        ])
                      ),
                    ),
                  ],
                ),
              ),
      );
  }
}
