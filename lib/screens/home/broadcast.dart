import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:pytch/services/db_event.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Broadcast extends StatefulWidget {
  Broadcast({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _BroadcastState createState() => _BroadcastState();
}

class _BroadcastState extends State<Broadcast> {
  var eventid;

  bool _offer = false;
  RTCPeerConnection _peerConnection;
  MediaStream _stream;
  RTCVideoRenderer _renderer = new RTCVideoRenderer();
  final sdpController = TextEditingController();

  @override
  dispose() {
    _renderer.dispose();
    sdpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  initRenderers() async {
    await _renderer.initialize();
    //await _remoteRenderer.initialize();
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': true,
    };

    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _renderer.srcObject = stream;
    _stream = stream;
    return stream;
  }

  _createPeerConnection() async {
    print('in _createPeerConnection');

    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": false,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };

    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);

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
      print('onIceConnectionState');
      print(e);
    };

    pc.onAddStream = (stream) {
      print('addStream: ' + stream.id);
      //_remoteRenderer.srcObject = stream;
    };
    _peerConnection = pc;
    //return pc;
  }

  void _addStream() {
    print('in _addStream');

    _peerConnection.addStream(_stream);
  }

  void _createEvent() async {
    var uuid = Uuid();
    eventid = uuid.v4();
    await DbEventService(uid: eventid).createEventData('Manly round 5', '1234');
  }

  void _broadcast() async {
    FirebaseFirestore.instance
        .collection('events')
        .doc(eventid)
        .collection('PeerConnections')
        .where('offerCreated', isEqualTo: 'N')
        .snapshots()
        .listen((event) {
      print('New peer connection for event eventid');
      print('create Offer');
      event.docs.forEach((doc) {
        print('looping');
        print(doc["connected"]);
        print(doc.reference.id);
        createConnection(doc.reference.id);
        // We know the peerconnection id so can listen for the document. Can check that candidate and anser are set to Y
        FirebaseFirestore.instance
            .collection('events')
            .doc(eventid)
            .collection('PeerConnections')
            .doc(doc.reference.id)
            .snapshots()
            .listen((event) {
          if (event.data()['candidatesCreated'] == 'Y') {
            print('Candidates created');
            setRemoteDetails(event.data()['answer']['sdp'],
                event.data()['candidate']['sdp']);
          }
        });
      });
    });
  }

  void setRemoteDetails(String answersdp, String candidatesdp) async {
    sdpController.text = answersdp;
    await _setRemoteDescription();

    sdpController.text = candidatesdp;
    await _addCandidate();
  }

  void createConnection(String pcid) async {
    await _createPeerConnection();
    await _addStream();
    await _createOffer(pcid);
  }

  _createOffer(String pcid) async {
    print('in _createOffer');

    RTCSessionDescription description = await _peerConnection
        .createOffer({'offerToReceiveAudio': 0, 'offerToReceiveVideo': 0});
    // await _peerConnection.createOffer({'offerToReceiveVideo': 1});
    print('created _createOffer');

    var session = parse(description.sdp);
    print(json.encode(session));
    _offer = true;

    await _peerConnection.setLocalDescription(description);
    print('created setLocalDescription');

    await FirebaseFirestore.instance
        .collection('events')
        .doc(eventid)
        .collection('PeerConnections')
        .doc(pcid)
        .update({
          'offerCreated': 'Y',
          'offer': {'type': description.type, 'sdp': json.encode(session)},
        })
        .then((value) => print("Offer Property updated"))
        .catchError(
            (error) => print("Failed to update offer property: $error"));

    print('herrrrrrrrrrrrrrrrre');
  }

  void _setRemoteDescription() async {
    String jsonString = sdpController.text;
    dynamic session = await jsonDecode('$jsonString');

    String sdp = write(session, null);

    RTCSessionDescription description =
        new RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');
    print(description.toMap());

    await _peerConnection.setRemoteDescription(description);
  }

  void _addCandidate() async {
    String jsonString = sdpController.text;
    dynamic session = await jsonDecode('$jsonString');
    print(session['candidate']);
    dynamic candidate = new RTCIceCandidate(
        session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
    await _peerConnection.addCandidate(candidate);
  }

  SizedBox videoRenderers() => SizedBox(
      height: 210,
      child: Row(children: [
        Flexible(
          child: new Container(
              key: new Key("local"),
              margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              decoration: new BoxDecoration(color: Colors.black),
              child: new RTCVideoView(
                _renderer,
                mirror: true,
              )),
        ),
      ]));

  _checkPCState() => print(_peerConnection.iceConnectionState);

  Row connectionState() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        new RaisedButton(
          onPressed: _checkPCState,
          child: Text('Connection State'),
          color: Colors.amber,
          //style: TextButton.styleFrom(primary: Colors.green),
        )
      ]);

  Row openMediaButton() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        new RaisedButton(
          onPressed: _createPeerConnection(),
          child: Text('Audio On'),
          color: Colors.amber,
          //style: TextButton.styleFrom(primary: Colors.green),
        )
      ]);

  Row offerAndAnswerButtons() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        // new RaisedButton(
        //   // onPressed: () {
        //   //   return showDialog(
        //   //       context: context,
        //   //       builder: (context) {
        //   //         return AlertDialog(
        //   //           content: Text(sdpController.text),
        //   //         );
        //   //       });
        //   // },
        //   onPressed: _createOffer('pcid'),
        //   child: Text('Broadcast'),
        //   color: Colors.amber,
        //   ),
        // RaisedButton(
        //   onPressed: _createAnswer,
        //   child: Text('Answer'),
        //   color: Colors.amber,
        // ),
      ]);

  Row sdpCandidateButtons() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        RaisedButton(
          onPressed: initRenderers,
          child: Text('Initiate Renders'),
          color: Colors.amber,
        ),
        RaisedButton(
          onPressed: _getUserMedia,
          child: Text('Get User Media'),
          color: Colors.amber,
        ),
        RaisedButton(
          onPressed: _createEvent,
          child: Text('Create Event'),
          color: Colors.amber,
        ),
        RaisedButton(
          onPressed: _broadcast,
          child: Text('Start Broadcasting'),
          color: Colors.amber,
        ),
        RaisedButton(
          onPressed: _createPeerConnection,
          child: Text('Create Peer Connection'),
          color: Colors.amber,
        ),
        RaisedButton(
          onPressed: _addStream,
          child: Text('Add PC to Stream'),
          color: Colors.amber,
        ),
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
              //connectionState(),
              //openMediaButton(),
              //offerAndAnswerButtons(),
              sdpCandidatesTF(),
              sdpCandidateButtons(),
            ])));
  }
}
