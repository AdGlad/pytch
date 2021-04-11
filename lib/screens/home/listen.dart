import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/web/rtc_session_description.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';
// AG
import 'package:pytch/services/db_event.dart';
import 'package:pytch/models/event.dart';
import 'package:pytch/models/candidate.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
// AG

class Listen extends StatefulWidget {
  // AG
  Listen({Key key, this.event, this.title}) : super(key: key);
  final EventData event;
  // AG
  final String title;

  @override
  _ListenState createState() => _ListenState();
}

class _ListenState extends State<Listen> {



  bool _offer = false;
  RTCPeerConnection _peerConnection;
  MediaStream _localStream;
  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
  //EventData eventdata;
  final sdpController = TextEditingController();
  String _candidates;

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
    // AG
    sdpController.text = widget.event.offer;
    _setRemoteDescription();
    _createAnswer();
    // AG
    });
    super.initState();
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();




  }

  void _createOffer() async {
    // AG
    var uuid = Uuid();
    var eventid = uuid.v4();
    // AG
    RTCSessionDescription description =
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
    // DbEventService(uid: eventid).createEventData('Manly round 3', '1234');
    // DbEventService(uid: eventid).updateEventoffer(description.type, json.encode(session));
    // AG
  }

  void _createAnswer() async {
    RTCSessionDescription description =
        await _peerConnection.createAnswer({'offerToReceiveVideo': 1});

    var session = parse(description.sdp);

    //print(json.encode(session));
    // print(json.encode({
    //       'sdp': description.sdp.toString(),
    //       'type': description.type.toString(),
    //     }));

    _peerConnection.setLocalDescription(description);
    // AG
    print(widget.event.id);
    print(widget.event.eventname);

    DbEventService(uid: widget.event.id).updateEventanswer(description.type, json.encode(session));

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

    bool _firstCandidate = true;

      pc.onIceCandidate = (e) {

        if (_firstCandidate) {
          _firstCandidate = false;
                DbEventService(uid: widget.event.id).updateEventcandidate('candidate',
                     json.encode({
                     'candidate': e.candidate.toString(),
                      'sdpMid': e.sdpMid.toString(),
                    'sdpMlineIndex': e.sdpMlineIndex,
                    })
                );        }
           };

    pc.onIceConnectionState = (e) {
      print(e);
    };

    pc.onAddStream = (stream) {
      print('addStream: ' + stream.id);
      _remoteRenderer.srcObject = stream;
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
        //   onPressed: _createOffer,
        //   child: Text('Offer'),
        //   color: Colors.amber,
        // ),
        RaisedButton(
          onPressed: _createAnswer,
          child: Text('Listen'),
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
          videoRenderers(),
          offerAndAnswerButtons(),
         // sdpCandidatesTF(),
         // sdpCandidateButtons(),
        ])));
  }
}
