import 'dart:convert';

class Answer {
  
  String sdp;
  String candidate;
  
  Answer(this.sdp, this.candidate);
  
  factory Answer.fromJson(dynamic json) {
    return Answer(json['sdp'] as String, 
                  json['candidate'] as String);
  }
  
  @override
  String toString() {
    return '{ ${this.sdp}, ${this.candidate}}';
  }
  
}
class Event {
  final String id;

  Event({this.id});

}

class EventData {
  final String id;
  final String eventname;
  final String offer;
  final String answer;
  final String candidate;
  List<Answer> answers;


  EventData({this.id,this.eventname,this.offer,this.answer,this.candidate,this.answers});

  factory EventData.fromJson(dynamic json) {
    if (json['answers'] != null) {
        var answerlist = json["answers"] as List;
        List<Answer> _answers = answerlist.map( (answerjson) => Answer.fromJson(answerjson) ).toList();
          return EventData(id: json['id'] as String,
                 eventname: json['eventname'] as String,
                 offer: json['offer'] as String,
                 answer: json['answer'] as String,
                 candidate: json['candidate'] as String,
                 answers: _answers);
    } else {
          return EventData(id: json['id'] as String,
                 eventname: json['eventname'] as String,
                 offer: json['offer'] as String,
                 answer: json['answer'] as String,
                 candidate: json['candidate'] as String);
    }
  }

  @override
  String toString() {
    return '{ ${this.id}, ${this.eventname},${this.offer}, ${this.answer}, ${this.candidate}, ${this.answers} }';
  }

}