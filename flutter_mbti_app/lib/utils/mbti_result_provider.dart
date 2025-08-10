import 'package:flutter/foundation.dart';
import '../models/models.dart';
import 'mbti_calculator.dart';

class MBTIResultProvider extends ChangeNotifier {
  TestResult? _currentResult;
  List<TestResult> _testHistory = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  TestResult? get currentResult => _currentResult;
  List<TestResult> get testHistory => List.unmodifiable(_testHistory);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasResult => _currentResult != null;

  /// 로딩 상태 설정
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// 에러 상태 설정
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  /// 초기 데이터 로드
  Future<void> initialize() async {
    _setLoading(true);
    _setError(null);

    try {
      // 최신 결과 로드
      _currentResult = await MBTICalculator.getLatestTestResult();
      
      // 테스트 히스토리 로드
      _testHistory = await MBTICalculator.getTestResultHistory();
      
    } catch (e) {
      _setError('데이터를 불러오는데 실패했습니다: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// 새로운 테스트 결과 계산 및 저장
  Future<void> calculateAndSaveResult({
    required List<UserAnswer> answers,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      // 테스트 결과 계산
      final result = await MBTICalculator.calculateTestResult(
        answers: answers,
        startTime: startTime,
        endTime: endTime,
      );

      // 결과 저장
      await MBTICalculator.saveTestResult(result);

      // 상태 업데이트
      _currentResult = result;
      _testHistory.add(result);

      // 최대 10개까지만 보관
      if (_testHistory.length > 10) {
        _testHistory.removeAt(0);
      }

    } catch (e) {
      _setError('테스트 결과를 저장하는데 실패했습니다: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// 테스트 히스토리 새로고침
  Future<void> refreshHistory() async {
    _setLoading(true);
    _setError(null);

    try {
      _testHistory = await MBTICalculator.getTestResultHistory();
    } catch (e) {
      _setError('히스토리를 불러오는데 실패했습니다: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// 모든 테스트 결과 삭제
  Future<void> clearAllResults() async {
    _setLoading(true);
    _setError(null);

    try {
      await MBTICalculator.clearTestResults();
      _currentResult = null;
      _testHistory.clear();
    } catch (e) {
      _setError('데이터를 삭제하는데 실패했습니다: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// 특정 테스트 결과를 현재 결과로 설정
  void setCurrentResult(TestResult result) {
    _currentResult = result;
    notifyListeners();
  }

  /// 에러 메시지 클리어
  void clearError() {
    _setError(null);
  }

  /// MBTI 유형별 호환성 점수 계산
  Map<MBTIType, int> getCompatibilityScores() {
    if (_currentResult == null) return {};

    final currentType = _currentResult!.resultType;
    final scores = <MBTIType, int>{};

    for (final type in MBTIType.values) {
      if (type != currentType) {
        scores[type] = MBTICalculator.calculateCompatibilityScore(currentType, type);
      }
    }

    // 점수별로 정렬
    final sortedEntries = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedEntries);
  }

  /// 차원별 강점 분석
  Map<String, double> getDimensionStrengths() {
    if (_currentResult == null) return {};
    return MBTICalculator.analyzeDimensionStrengths(_currentResult!.totalScores);
  }

  /// 테스트 통계 정보
  Future<Map<String, dynamic>> getTestStatistics() async {
    return await MBTICalculator.getTestStatistics();
  }

  /// 특정 MBTI 유형의 출현 빈도
  Map<MBTIType, int> getTypeFrequency() {
    final frequency = <MBTIType, int>{};
    
    for (final result in _testHistory) {
      frequency[result.resultType] = (frequency[result.resultType] ?? 0) + 1;
    }

    return frequency;
  }

  /// 최근 테스트들의 평균 지속 시간
  Duration getAverageTestDuration() {
    if (_testHistory.isEmpty) return Duration.zero;

    int totalMilliseconds = 0;
    for (final result in _testHistory) {
      totalMilliseconds += result.testDuration.inMilliseconds;
    }

    return Duration(milliseconds: totalMilliseconds ~/ _testHistory.length);
  }

  /// 현재 결과와 이전 결과들 간의 일관성 점수 계산 (0-100)
  double getConsistencyScore() {
    if (_testHistory.length < 2) return 100.0;

    final currentType = _currentResult?.resultType;
    if (currentType == null) return 0.0;

    int sameTypeCount = 0;
    for (final result in _testHistory) {
      if (result.resultType == currentType) {
        sameTypeCount++;
      }
    }

    return (sameTypeCount / _testHistory.length) * 100;
  }

  /// 특정 차원에서의 점수 추이 (최근 테스트들)
  List<Map<String, dynamic>> getDimensionTrends() {
    if (_testHistory.isEmpty) return [];

    return _testHistory.map((result) => {
      'date': result.completedAt,
      'scores': {
        'E': result.totalScores.e,
        'I': result.totalScores.i,
        'S': result.totalScores.s,
        'N': result.totalScores.n,
        'T': result.totalScores.t,
        'F': result.totalScores.f,
        'J': result.totalScores.j,
        'P': result.totalScores.p,
      },
      'percentages': result.dimensionPercentages,
    }).toList();
  }
}