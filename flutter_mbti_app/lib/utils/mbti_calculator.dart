import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class MBTICalculator {
  static const String _testResultsKey = 'mbti_test_results';
  static const String _latestResultKey = 'mbti_latest_result';
  
  static Map<MBTIType, MBTIResult>? _mbtiResults;

  /// 16개 답변을 기반으로 MBTI 점수 계산
  static MBTIScores calculateScores(List<UserAnswer> answers) {
    MBTIScores totalScores = const MBTIScores();
    
    for (final answer in answers) {
      totalScores = totalScores + answer.contributedScores;
    }
    
    return totalScores;
  }

  /// 점수를 기반으로 MBTI 유형 결정
  static MBTIType determineType(MBTIScores scores) {
    return MBTIResult.calculateType(
      scores.e, scores.i, 
      scores.s, scores.n, 
      scores.t, scores.f, 
      scores.j, scores.p
    );
  }

  /// MBTI 결과 데이터 로드
  static Future<Map<MBTIType, MBTIResult>> loadMBTIResults() async {
    if (_mbtiResults != null) {
      return _mbtiResults!;
    }

    try {
      final String data = await rootBundle.loadString('assets/data/mbti_results.json');
      final Map<String, dynamic> jsonData = json.decode(data);
      
      _mbtiResults = <MBTIType, MBTIResult>{};
      
      for (final entry in jsonData.entries) {
        final typeKey = entry.key.toLowerCase();
        final mbtiType = MBTIType.values.firstWhere(
          (type) => type.name == typeKey,
        );
        _mbtiResults![mbtiType] = MBTIResult.fromJson(entry.value);
      }
      
      return _mbtiResults!;
    } catch (e) {
      throw Exception('MBTI 결과 데이터를 로드할 수 없습니다: $e');
    }
  }

  /// 전체 테스트 결과 계산
  static Future<TestResult> calculateTestResult({
    required List<UserAnswer> answers,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    if (answers.length != 16) {
      throw ArgumentError('16개의 답변이 필요합니다. 현재: ${answers.length}개');
    }

    // 점수 계산
    final totalScores = calculateScores(answers);
    
    // MBTI 유형 결정
    final mbtiType = determineType(totalScores);
    
    // MBTI 결과 데이터 로드
    final mbtiResults = await loadMBTIResults();
    final mbtiResult = mbtiResults[mbtiType];
    
    if (mbtiResult == null) {
      throw Exception('$mbtiType에 대한 결과 데이터를 찾을 수 없습니다');
    }

    // 테스트 결과 생성
    final testResult = TestResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      completedAt: endTime,
      totalScores: totalScores,
      resultType: mbtiType,
      mbtiResult: mbtiResult,
      answers: answers,
      testDuration: endTime.difference(startTime),
    );

    return testResult;
  }

  /// 테스트 결과를 SharedPreferences에 저장
  static Future<void> saveTestResult(TestResult result) async {
    final prefs = await SharedPreferences.getInstance();
    
    // 최신 결과 저장
    await prefs.setString(_latestResultKey, json.encode(result.toJson()));
    
    // 결과 히스토리 저장
    final existingResults = await getTestResultHistory();
    existingResults.add(result);
    
    // 최대 10개까지만 보관
    if (existingResults.length > 10) {
      existingResults.removeRange(0, existingResults.length - 10);
    }
    
    final historyJson = existingResults.map((r) => r.toJson()).toList();
    await prefs.setString(_testResultsKey, json.encode(historyJson));
  }

  /// 최신 테스트 결과 불러오기
  static Future<TestResult?> getLatestTestResult() async {
    final prefs = await SharedPreferences.getInstance();
    final resultString = prefs.getString(_latestResultKey);
    
    if (resultString == null) {
      return null;
    }

    try {
      final resultJson = json.decode(resultString) as Map<String, dynamic>;
      return TestResult.fromJson(resultJson);
    } catch (e) {
      return null;
    }
  }

  /// 테스트 결과 히스토리 불러오기
  static Future<List<TestResult>> getTestResultHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyString = prefs.getString(_testResultsKey);
    
    if (historyString == null) {
      return [];
    }

    try {
      final historyJson = json.decode(historyString) as List;
      return historyJson
          .map((json) => TestResult.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// 저장된 테스트 결과 모두 삭제
  static Future<void> clearTestResults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_latestResultKey);
    await prefs.remove(_testResultsKey);
  }

  /// MBTI 유형별 호환성 점수 계산
  static int calculateCompatibilityScore(MBTIType type1, MBTIType type2) {
    if (type1 == type2) return 100;
    
    final type1String = type1.name;
    final type2String = type2.name;
    
    int score = 0;
    
    // 각 차원별로 비교
    for (int i = 0; i < 4; i++) {
      if (type1String[i] == type2String[i]) {
        score += 25; // 같은 차원일 때 25점
      } else {
        // 상반된 차원일 때는 호환성에 따라 다른 점수
        if (_isComplementaryDimension(type1String[i], type2String[i], i)) {
          score += 15; // 보완적인 관계일 때 15점
        } else {
          score += 5; // 충돌 가능성이 있을 때 5점
        }
      }
    }
    
    return score;
  }

  /// 차원별 보완적 관계 판단
  static bool _isComplementaryDimension(String char1, String char2, int position) {
    switch (position) {
      case 0: // E/I
        return (char1 == 'e' && char2 == 'i') || (char1 == 'i' && char2 == 'e');
      case 1: // S/N
        return (char1 == 's' && char2 == 'n') || (char1 == 'n' && char2 == 's');
      case 2: // T/F
        return (char1 == 't' && char2 == 'f') || (char1 == 'f' && char2 == 't');
      case 3: // J/P
        return (char1 == 'j' && char2 == 'p') || (char1 == 'p' && char2 == 'j');
      default:
        return false;
    }
  }

  /// MBTI 유형의 강점 분석
  static Map<String, double> analyzeDimensionStrengths(MBTIScores scores) {
    final Map<String, double> strengths = {};
    
    final totalE = scores.e + scores.i;
    final totalS = scores.s + scores.n;
    final totalT = scores.t + scores.f;
    final totalJ = scores.j + scores.p;
    
    if (totalE > 0) {
      strengths['Extraversion'] = (scores.e / totalE) * 100;
      strengths['Introversion'] = (scores.i / totalE) * 100;
    }
    
    if (totalS > 0) {
      strengths['Sensing'] = (scores.s / totalS) * 100;
      strengths['Intuition'] = (scores.n / totalS) * 100;
    }
    
    if (totalT > 0) {
      strengths['Thinking'] = (scores.t / totalT) * 100;
      strengths['Feeling'] = (scores.f / totalT) * 100;
    }
    
    if (totalJ > 0) {
      strengths['Judging'] = (scores.j / totalJ) * 100;
      strengths['Perceiving'] = (scores.p / totalJ) * 100;
    }
    
    return strengths;
  }

  /// 테스트 통계 정보 계산
  static Future<Map<String, dynamic>> getTestStatistics() async {
    final results = await getTestResultHistory();
    
    if (results.isEmpty) {
      return {
        'totalTests': 0,
        'averageDuration': Duration.zero,
        'mostFrequentType': null,
        'typeDistribution': <String, int>{},
      };
    }
    
    final typeCount = <MBTIType, int>{};
    Duration totalDuration = Duration.zero;
    
    for (final result in results) {
      typeCount[result.resultType] = (typeCount[result.resultType] ?? 0) + 1;
      totalDuration += result.testDuration;
    }
    
    final mostFrequentType = typeCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    
    return {
      'totalTests': results.length,
      'averageDuration': Duration(
        milliseconds: totalDuration.inMilliseconds ~/ results.length
      ),
      'mostFrequentType': mostFrequentType,
      'typeDistribution': typeCount.map(
        (key, value) => MapEntry(key.name.toUpperCase(), value)
      ),
    };
  }
}