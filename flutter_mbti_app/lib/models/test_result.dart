import 'mbti_result.dart';
import 'question.dart';

class TestResult {
  final String id;
  final DateTime completedAt;
  final MBTIScores totalScores;
  final MBTIType resultType;
  final MBTIResult mbtiResult;
  final List<UserAnswer> answers;
  final Duration testDuration;

  const TestResult({
    required this.id,
    required this.completedAt,
    required this.totalScores,
    required this.resultType,
    required this.mbtiResult,
    required this.answers,
    required this.testDuration,
  });

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      id: json['id'] as String,
      completedAt: DateTime.parse(json['completedAt'] as String),
      totalScores: MBTIScores.fromJson(json['totalScores'] as Map<String, dynamic>),
      resultType: MBTIType.values.firstWhere(
        (e) => e.name == json['resultType'],
      ),
      mbtiResult: MBTIResult.fromJson(json['mbtiResult'] as Map<String, dynamic>),
      answers: (json['answers'] as List)
          .map((e) => UserAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
      testDuration: Duration(milliseconds: json['testDurationMs'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'completedAt': completedAt.toIso8601String(),
      'totalScores': totalScores.toJson(),
      'resultType': resultType.name,
      'mbtiResult': mbtiResult.toJson(),
      'answers': answers.map((e) => e.toJson()).toList(),
      'testDurationMs': testDuration.inMilliseconds,
    };
  }

  Map<String, int> get dimensionScores {
    return {
      'E': totalScores.e,
      'I': totalScores.i,
      'S': totalScores.s,
      'N': totalScores.n,
      'T': totalScores.t,
      'F': totalScores.f,
      'J': totalScores.j,
      'P': totalScores.p,
    };
  }

  Map<String, double> get dimensionPercentages {
    final eTotal = totalScores.e + totalScores.i;
    final sTotal = totalScores.s + totalScores.n;
    final tTotal = totalScores.t + totalScores.f;
    final jTotal = totalScores.j + totalScores.p;

    return {
      'E': eTotal > 0 ? (totalScores.e / eTotal) * 100 : 0.0,
      'I': eTotal > 0 ? (totalScores.i / eTotal) * 100 : 0.0,
      'S': sTotal > 0 ? (totalScores.s / sTotal) * 100 : 0.0,
      'N': sTotal > 0 ? (totalScores.n / sTotal) * 100 : 0.0,
      'T': tTotal > 0 ? (totalScores.t / tTotal) * 100 : 0.0,
      'F': tTotal > 0 ? (totalScores.f / tTotal) * 100 : 0.0,
      'J': jTotal > 0 ? (totalScores.j / jTotal) * 100 : 0.0,
      'P': jTotal > 0 ? (totalScores.p / jTotal) * 100 : 0.0,
    };
  }
}

class UserAnswer {
  final int questionId;
  final String selectedOption; // 'A' or 'B'
  final MBTIScores contributedScores;
  final DateTime answeredAt;

  const UserAnswer({
    required this.questionId,
    required this.selectedOption,
    required this.contributedScores,
    required this.answeredAt,
  });

  factory UserAnswer.fromJson(Map<String, dynamic> json) {
    return UserAnswer(
      questionId: json['questionId'] as int,
      selectedOption: json['selectedOption'] as String,
      contributedScores: MBTIScores.fromJson(json['contributedScores'] as Map<String, dynamic>),
      answeredAt: DateTime.parse(json['answeredAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selectedOption': selectedOption,
      'contributedScores': contributedScores.toJson(),
      'answeredAt': answeredAt.toIso8601String(),
    };
  }
}