class Leader {
  final int score;
  final String name;
  final String colorVal;
  Leader(this.score,this.name,this.colorVal);

  Leader.fromMap(Map<String, dynamic> map)
      : assert(map['score'] != null),
        assert(map['name'] != null),
        assert(map['colorVal'] != null),
        name = map['name'],
        score = map['score'],
        colorVal=map['colorVal'];

  @override
  String toString() => "Record<$score:$name>";
}