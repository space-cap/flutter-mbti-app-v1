class Question {
  final int id;
  final String text;
  final QuestionOption optionA;
  final QuestionOption optionB;

  const Question({
    required this.id,
    required this.text,
    required this.optionA,
    required this.optionB,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      text: json['text'] as String,
      optionA: QuestionOption.fromJson(json['optionA'] as Map<String, dynamic>),
      optionB: QuestionOption.fromJson(json['optionB'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'optionA': optionA.toJson(),
      'optionB': optionB.toJson(),
    };
  }
}

class QuestionOption {
  final String text;
  final MBTIScores scores;

  const QuestionOption({
    required this.text,
    required this.scores,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      text: json['text'] as String,
      scores: MBTIScores.fromJson(json['scores'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'scores': scores.toJson(),
    };
  }
}

class MBTIScores {
  final int e; // Extraversion
  final int i; // Introversion
  final int s; // Sensing
  final int n; // Intuition
  final int t; // Thinking
  final int f; // Feeling
  final int j; // Judging
  final int p; // Perceiving

  const MBTIScores({
    this.e = 0,
    this.i = 0,
    this.s = 0,
    this.n = 0,
    this.t = 0,
    this.f = 0,
    this.j = 0,
    this.p = 0,
  });

  factory MBTIScores.fromJson(Map<String, dynamic> json) {
    return MBTIScores(
      e: json['e'] as int? ?? 0,
      i: json['i'] as int? ?? 0,
      s: json['s'] as int? ?? 0,
      n: json['n'] as int? ?? 0,
      t: json['t'] as int? ?? 0,
      f: json['f'] as int? ?? 0,
      j: json['j'] as int? ?? 0,
      p: json['p'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'e': e,
      'i': i,
      's': s,
      'n': n,
      't': t,
      'f': f,
      'j': j,
      'p': p,
    };
  }

  MBTIScores operator +(MBTIScores other) {
    return MBTIScores(
      e: e + other.e,
      i: i + other.i,
      s: s + other.s,
      n: n + other.n,
      t: t + other.t,
      f: f + other.f,
      j: j + other.j,
      p: p + other.p,
    );
  }
}