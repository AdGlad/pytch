import 'dart:convert';
import 'package:pytch/models/eventanswer.dart';
void main() {

  String answerstring = '{"answers": [  {"sdp": "sdp json1", "candidate": "candidate json1"}, {"sdp": "sdp json2", "candidate": "candidate json2"}]}';
  var answerlist = jsonDecode(answerstring)["answers"] as List;
  List<Answer> answers = answerlist.map( (answerjson) => Answer.fromJson(answerjson) ).toList();
  print(answers);

  //String eventstring = '{ "id": "123456", "eventname": "Manly round 2","offer": "offername"}';
  String eventstring = '{ "id": "123456", "eventname": "Manly round 2","offer": "offername","answers": [  {"sdp": "sdp json1", "candidate": "candidate json1"}, {"sdp": "sdp json2", "candidate": "candidate json2"}]}';
  
  EventData event =EventData.fromJson(jsonDecode(eventstring));
  print(event);
  
}