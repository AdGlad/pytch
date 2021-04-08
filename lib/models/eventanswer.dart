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
class EventData {
  
  String id;
  String eventname;
  String offer;
  final String answer;
  final String candidate;

  List<Answer> answers;
  
  EventData(this.id,this.eventname,this.offer,this.answer,this.candidate,[this.answers]);
  
  //EventData(this.id,this.eventname);
  
  factory EventData.fromJson(dynamic json) {
    if (json['answers'] != null) {
        var answerlist = json["answers"] as List;
        List<Answer> _answers = answerlist.map( (answerjson) => Answer.fromJson(answerjson) ).toList();
          return EventData(json['id'] as String,
                 json['eventname'] as String,
                 json['offer'] as String,
                 json['answer'] as String,
                 json['candidate'] as String,
                 _answers);
    } else {
          return EventData(json['id'] as String,
                 json['eventname'] as String,
                 json['offer'] as String,
                 json['answer'] as String,
                 json['candidate'] as String);
    }
  }
  
  @override
  String toString() {
    return '{ ${this.id}, ${this.eventname},${this.offer}, ${this.answers} }';
  }
  
}
