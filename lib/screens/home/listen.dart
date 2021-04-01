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
import 'package:pytch/models/event.dart';


class Listen extends StatefulWidget {

final EventData event;

  Listen({Key key, this.event, this.title}) : super(key: key);
  final String title;
  @override
  _ListenState createState() => _ListenState();
}

class _ListenState extends State<Listen> {
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
    // initRenderers();
    // _createPeerConnection().then((pc) {
    //   _peerConnection = pc;
    // });
    super.initState();
  }

  initRenderers() async {
    await _localRenderer.initialize();
   // await _remoteRenderer.initialize();
  }

  void _showEvent() async {
   
    print('******************************');
    print(widget.event.eventname);
    print(widget.event.uid);
    print(widget.event.offer);
    print('******************************');


  }

  void _createAnswer() async {
       print('_createAnswer AG');
       initRenderers();
       _createPeerConnection().then((pc){_peerConnection = pc;});

     RTCSessionDescription description =
         await _peerConnection.createAnswer({'offerToReceiveVideo': 1});
     //DocumentSnapshot jsonString = await Firestore.instance.collection('events').document('0aba43ea-64f4-4e9a-9edc-bf24c4042898').get();
     //DocumentSnapshot jsonString = await Firestore.instance.collection('events').document(widget.event.uid).get();
    
    //  print('##########################################');
    //  print(jsonString.data['eventname']);
    //  print(jsonString.data['offer']['sdp']);
    //  print('##########################################');
    // print('##########################################');
    //  print(widget.event.eventname);
    //  print(widget.event.offer);
    //  print('##########################################');
    //_showEvent();
    var session = parse(description.sdp);
        print(json.encode(session));
        print(json.encode({
               'sdp': description.sdp.toString(),
               'type': description.type.toString(),
               }));

     _peerConnection.setLocalDescription(description);
     DbEventService(uid: widget.event.uid).updateEventanswer(description.type, json.encode(session));
  }

  void _setRemoteDescription() async {
  print('_setRemoteDescription AG');
    // This is where we need to apply SDP from Firebase
    //DocumentSnapshot jsonString = await Firestore.instance.collection('events').document('0aba43ea-64f4-4e9a-9edc-bf24c4042898').get();
    //DocumentSnapshot jsonString = await Firestore.instance.collection('events').document(widget.event.uid).get();
    //String jsonString = await Firestore.instance.collection('events').document(widget.event.uid).get();
     
     //print(widget.event.eventname);
    // print(widget.event.offer);

    //dynamic session = await jsonDecode('$jsonString');

    // AG   sdpController.text  = widget.event.offer;
    
    String jsonString = sdpController.text;
    dynamic session = await jsonDecode('$jsonString');
    //String session =widget.event.offer;
    //String sdp = session;

    String sdp = write(session, null);
    print('PPPPPPPPPPPPPPPPPPPPPPPP');
    print(sdp);
    print('PPPPPPPPPPPPPPPPPPPPPPPP');

    // RTCSessionDescription description =
    //     new RTCSessionDescription(session['sdp'], session['type']);
    // RTCSessionDescription description =
    //     new RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');

        RTCSessionDescription description =
        new RTCSessionDescription(sdp, 'answer' );

    print('##########################################');
    print(description.toMap());
    print('##########################################');

    await _peerConnection.setRemoteDescription(description);
    print('EEEEEEEEEEEEEEEEEE');



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

    // pc.onAddStream = (stream) {
    //   print('addStream: ' + stream.id);
    //   _remoteRenderer.srcObject = stream;
    // };
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
   // print('ZZZZZZ');
   // print('offer');

    // _localStream = stream;
   // print(stream);
   // print('AAAAA');

    _localRenderer.srcObject = stream;
   // _localRenderer.mirror = true;
   // print('BBBBB');

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
        // Flexible(
        //   child: new Container(
        //       key: new Key("remote"),
        //       margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        //       decoration: new BoxDecoration(color: Colors.black),
        //       child: new RTCVideoView(_remoteRenderer)),
        // )
      ]));

  Row offerAndAnswerButtons() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        new 
        // RaisedButton(
        //   onPressed: _showEvent,
        //   child: Text('Show Event'),
        //   color: Colors.amber,
        // ),
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
        title: Text('Listen'),
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
