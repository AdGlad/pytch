class Candidate {
  String candidate ;
  String sdpMid    ;
  int sdpMlineIndex ;

  Candidate(this.candidate, this.sdpMid, this.sdpMlineIndex);

  Map toJson() => {
        'candidate': candidate,
        'sdpMid': sdpMid,
        'sdpMlineIndex': sdpMlineIndex,
      };
      
}