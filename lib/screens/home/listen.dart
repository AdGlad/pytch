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
import 'package:cloud_firestore/cloud_firestore.dart';

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
  MediaStream _stream;
  RTCVideoRenderer _renderer = new RTCVideoRenderer();
  final sdpController = TextEditingController();
  String pcid ;
  var uuid = Uuid();

  @override
  dispose() {
    _renderer.dispose();
    sdpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
  //  initRenderers();
    // _createPeerConnection().then((pc) {
    //   _peerConnection = pc;
    // // AG
    // sdpController.text = widget.event.offer;
    // //_setRemoteDescription();
    // //_createAnswer();
    // // AG
    // });
    super.initState();
  }

  initRenderers() async {
    //await _localRenderer.initialize();
    await _renderer.initialize();
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': false,
      'video': {
        'facingMode': 'user',
      },
  };

    MediaStream stream = await navigator.getUserMedia(mediaConstraints);

     _stream = stream;
    //_localRenderer.srcObject = stream;
    //_localRenderer.mirror = true;

    // _peerConnection.addStream(stream);
    return stream;
  }

  Future<void> createPC (var eventid) async {
      print('in createPC');
      pcid = uuid.v4();
      var _collectionReference = FirebaseFirestore.instance.collection('events');

       return _collectionReference
          .doc(eventid).collection("PeerConnections").doc(pcid).set({
            'offer': {'type': '','sdp': ''} ,
            'answer': {'type': '','sdp': ''} ,
            'candidate': {'type': '','sdp': ''} , 
            'connected': 'N' ,
            'offerCreated': 'N' ,
            'answerCreated': 'N' ,
            'candidatesCreated': 'N' ,
            'remoteDescAssigned': 'N' ,
            'candidateAssigned': 'N' ,
            })
          .then((value) => print("PeerCollection Added"))
          .catchError((error) => print("Failed to add PeerCollection: $error"));

    }

    createRDAnswer() async {
              await _setRemoteDescription(); 
              await _createAnswer();
    }

    _createPeerConnection() async {

      //String pcid ;
      //var uuid = Uuid();
      pcid = uuid.v4();

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

   // _stream = await _getUserMedia();

    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);
    // if (pc != null) print(pc);
    //pc.addStream(_stream);

    createPC(widget.event.id);
    
    print("pcid ${pcid}");

    FirebaseFirestore.instance.collection('events').doc(widget.event.id).collection('PeerConnections').doc(pcid).snapshots().listen((event) {
        print('Monitor peer connection for connection updates');
        //print(event.toString());
        //print(event.data().toString());
        //  print(event.data()['offerCreated']);
        //  print(event.data()['answerCreated']);
        //  print(event.data()['candidatesCreated']);
        //  print(event.data()['remoteDescAssigned']);
        //  print(event.data()['candidateAssigned']);

          if (event.data()['offerCreated']=='Y') {
              print('offerCreated');
              print('Create Answer');
                  if (event.data()['answerCreated']=='N') {
                     sdpController.text = event.data()['offer']['sdp'];
                        createRDAnswer();
                     }
             
          }
    });

    bool _firstCandidate = true;
    print(' before onIceCandidate loop ');

    pc.onIceCandidate = (e) {
      print('pc.onIceCandidate loop');
      if (e.candidate != null) {
        print(json.encode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMlineIndex,
        }));
      }
    };

    pc.onIceCandidate = (e) {
      print(' do onIceCandidate loop ');
      if (_firstCandidate) {
        _firstCandidate = false;
        // DbEventService(uid: widget.event.id).updateEventcandidate(
        //     'candidate',
        //     json.encode({
        //       'candidate': e.candidate.toString(),
        //       'sdpMid': e.sdpMid.toString(),
        //       'sdpMlineIndex': e.sdpMlineIndex,
        //     }));

           FirebaseFirestore.instance.collection('events').doc(widget.event.id).collection('PeerConnections').doc(pcid)
           .update({'candidatesCreated': 'Y',
             'candidate': {'type': 'candidate', 'sdp': json.encode({'candidate': e.candidate.toString(),'sdpMid': e.sdpMid.toString(),'sdpMlineIndex': e.sdpMlineIndex,}),}
           })
           .then((value) => print("Answer Property updated"))
           .catchError(
               (error) => print("Failed to update answer property: $error"));
      }
    };

    pc.onIceConnectionState = (e) {
      print('onIceConnectionState');
      print(e);
    };

    pc.onAddStream = (stream) {
      print('addStream: ' + stream.id);
      _renderer.srcObject = stream;
    };
   _peerConnection = pc;
    return pc;
  }

    void _addStream() {
     _peerConnection.addStream(_stream);
   }


   void _createAnswer() async {
     print('in _createAnswer');
    // await _createPeerConnection().then((pc) {
    //   _peerConnection = pc;
    //   // AG
    //   sdpController.text = widget.event.offer;
    //   //_setRemoteDescription();
      //_createAnswer();
      // AG
    ///});

    // print('_createAnswer');
    // await _setRemoteDescription();
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
    //print(widget.event.id);
    //print(widget.event.eventname);

    // DbEventService(uid: widget.event.id)
    //     .updateEventanswer(description.type, json.encode(session));

         await   FirebaseFirestore.instance.collection('events').doc(widget.event.id).collection('PeerConnections').doc(pcid)
           .update({'answerCreated': 'Y',
             'answer': {'type': description.type, 'sdp': json.encode(session)},

           })
           .then((value) => print("Answer Property updated"))
           .catchError(
               (error) => print("Failed to update answer property: $error"));


  }

  void _setRemoteDescription() async {
    print('_setRemoteDescription');
    String jsonString = sdpController.text;
    dynamic session = await jsonDecode('$jsonString');

    String sdp = write(session, null);

    // RTCSessionDescription description =
    //     new RTCSessionDescription(session['sdp'], session['type']);
    RTCSessionDescription description =
        new RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');
    //print(description.toMap());

    await _peerConnection.setRemoteDescription(description);
  }

  void _addCandidate() async {
    print('_addCandidate');
    String jsonString = sdpController.text;
    dynamic session = await jsonDecode('$jsonString');
    //print(session['candidate']);
    dynamic candidate = new RTCIceCandidate(
        session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
    await _peerConnection.addCandidate(candidate);
  }



 


  SizedBox videoRenderers() => SizedBox(
      height: 210,
      child: Row(children: [
        // Flexible(
        //   child: new Container(
        //     key: new Key("local"),
        //     margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        //     decoration: new BoxDecoration(color: Colors.black),
        //     child: new RTCVideoView(_localRenderer)
        //   ),
        // ),
        Flexible(
          child: new Container(
              key: new Key("remote"),
              margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              decoration: new BoxDecoration(color: Colors.black),
              child: new RTCVideoView(_renderer)),
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
          child: Text('Listen Now'),
          color: Colors.amber,
        ),
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
          onPressed: _createAnswer,
          child: Text('Create Answer'),
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
               sdpCandidatesTF(),
              sdpCandidateButtons(),
            ])));
  }
}
