import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mbti_app/models/models.dart';
import 'package:flutter_mbti_app/utils/mbti_calculator.dart';

void main() {
  group('MBTICalculator Tests', () {
    test('calculateScores should sum up all answer scores correctly', () {
      // Arrange
      final answers = [
        UserAnswer(
          questionId: 1,
          selectedOption: 'A',
          contributedScores: const MBTIScores(e: 2, i: 0, s: 1, n: 0, t: 0, f: 0, j: 0, p: 0),
          answeredAt: DateTime.now(),
        ),
        UserAnswer(
          questionId: 2,
          selectedOption: 'B',
          contributedScores: const MBTIScores(e: 0, i: 1, s: 0, n: 2, t: 0, f: 0, j: 0, p: 0),
          answeredAt: DateTime.now(),
        ),
      ];

      // Act
      final result = MBTICalculator.calculateScores(answers);

      // Assert
      expect(result.e, equals(2));
      expect(result.i, equals(1));
      expect(result.s, equals(1));
      expect(result.n, equals(2));
      expect(result.t, equals(0));
      expect(result.f, equals(0));
      expect(result.j, equals(0));
      expect(result.p, equals(0));
    });

    test('determineType should return correct MBTI type based on scores', () {
      // Test ENTJ
      const entjScores = MBTIScores(e: 5, i: 2, s: 2, n: 5, t: 6, f: 1, j: 4, p: 3);
      expect(MBTICalculator.determineType(entjScores), equals(MBTIType.entj));

      // Test ISFP
      final isfpScores = const MBTIScores(e: 1, i: 6, s: 5, n: 2, t: 2, f: 5, j: 2, p: 5);
      expect(MBTICalculator.determineType(isfpScores), equals(MBTIType.isfp));
    });

    test('calculateCompatibilityScore should return 100 for same types', () {
      final score = MBTICalculator.calculateCompatibilityScore(MBTIType.entj, MBTIType.entj);
      expect(score, equals(100));
    });

    test('calculateCompatibilityScore should return reasonable scores for different types', () {
      // ENTJ vs INFP (완전히 반대)
      final score1 = MBTICalculator.calculateCompatibilityScore(MBTIType.entj, MBTIType.infp);
      expect(score1, greaterThan(0));
      expect(score1, lessThan(100));

      // ENTJ vs ENTP (한 차원만 다름)
      final score2 = MBTICalculator.calculateCompatibilityScore(MBTIType.entj, MBTIType.entp);
      expect(score2, greaterThan(score1));
      expect(score2, lessThan(100));
    });

    test('analyzeDimensionStrengths should calculate percentages correctly', () {
      final scores = const MBTIScores(e: 3, i: 1, s: 2, n: 2, t: 4, f: 0, j: 1, p: 3);
      final strengths = MBTICalculator.analyzeDimensionStrengths(scores);

      expect(strengths['Extraversion'], equals(75.0)); // 3/(3+1) * 100
      expect(strengths['Introversion'], equals(25.0)); // 1/(3+1) * 100
      expect(strengths['Sensing'], equals(50.0)); // 2/(2+2) * 100
      expect(strengths['Intuition'], equals(50.0)); // 2/(2+2) * 100
      expect(strengths['Thinking'], equals(100.0)); // 4/(4+0) * 100
      expect(strengths['Feeling'], equals(0.0)); // 0/(4+0) * 100
    });
  });

  group('MBTIScores Tests', () {
    test('addition operator should work correctly', () {
      const scores1 = MBTIScores(e: 1, i: 2, s: 3, n: 4, t: 5, f: 6, j: 7, p: 8);
      const scores2 = MBTIScores(e: 2, i: 1, s: 1, n: 1, t: 1, f: 1, j: 1, p: 1);
      
      final result = scores1 + scores2;
      
      expect(result.e, equals(3));
      expect(result.i, equals(3));
      expect(result.s, equals(4));
      expect(result.n, equals(5));
      expect(result.t, equals(6));
      expect(result.f, equals(7));
      expect(result.j, equals(8));
      expect(result.p, equals(9));
    });

    test('fromJson and toJson should work correctly', () {
      const original = MBTIScores(e: 1, i: 2, s: 3, n: 4, t: 5, f: 6, j: 7, p: 8);
      final json = original.toJson();
      final restored = MBTIScores.fromJson(json);
      
      expect(restored.e, equals(original.e));
      expect(restored.i, equals(original.i));
      expect(restored.s, equals(original.s));
      expect(restored.n, equals(original.n));
      expect(restored.t, equals(original.t));
      expect(restored.f, equals(original.f));
      expect(restored.j, equals(original.j));
      expect(restored.p, equals(original.p));
    });
  });

  group('MBTIResult Tests', () {
    test('calculateType should determine correct type', () {
      expect(MBTIResult.calculateType(3, 1, 2, 2, 4, 0, 3, 1), equals(MBTIType.entj));
      expect(MBTIResult.calculateType(1, 3, 3, 1, 1, 3, 1, 3), equals(MBTIType.isfp));
    });
  });
}