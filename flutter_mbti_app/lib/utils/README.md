# MBTI Calculator & Provider 사용법

## 개요
이 패키지는 MBTI 테스트 결과 계산, 저장, 관리를 위한 유틸리티들을 제공합니다.

## 주요 구성 요소

### 1. MBTICalculator
MBTI 점수 계산 및 결과 판정을 담당하는 정적 클래스입니다.

#### 주요 기능:
- 16개 답변을 기반으로 MBTI 점수 계산
- MBTI 유형 결정
- SharedPreferences를 통한 결과 저장/불러오기
- 호환성 점수 계산
- 차원별 강점 분석

### 2. MBTIResultProvider
Provider 패턴을 사용한 상태 관리 클래스입니다.

#### 주요 기능:
- 테스트 결과 상태 관리
- 히스토리 관리
- 통계 정보 제공
- 일관성 분석

## 사용 예제

### 1. 기본 설정 (main.dart)
```dart
import 'package:provider/provider.dart';
import 'utils/mbti_result_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MBTIResultProvider(),
      child: MyApp(),
    ),
  );
}
```

### 2. 테스트 결과 계산 및 저장
```dart
// 답변 리스트 준비
final answers = <UserAnswer>[
  UserAnswer(
    questionId: 1,
    selectedOption: 'A',
    contributedScores: MBTIScores(e: 2, i: 0, s: 1, n: 0, t: 0, f: 0, j: 0, p: 0),
    answeredAt: DateTime.now(),
  ),
  // ... 16개 답변
];

// Provider를 통한 결과 계산 및 저장
final provider = context.read<MBTIResultProvider>();
await provider.calculateAndSaveResult(
  answers: answers,
  startTime: testStartTime,
  endTime: DateTime.now(),
);
```

### 3. 결과 조회
```dart
// 현재 결과 조회
Consumer<MBTIResultProvider>(
  builder: (context, provider, child) {
    if (provider.hasResult) {
      final result = provider.currentResult!;
      return Column(
        children: [
          Text('당신의 MBTI: ${result.resultType.name.toUpperCase()}'),
          Text('제목: ${result.mbtiResult.title}'),
          Text('별명: ${result.mbtiResult.nickname}'),
        ],
      );
    }
    return Text('결과가 없습니다.');
  },
)
```

### 4. 호환성 분석
```dart
final provider = context.read<MBTIResultProvider>();
final compatibilityScores = provider.getCompatibilityScores();

// 가장 호환성이 높은 유형
final bestMatch = compatibilityScores.entries.first;
print('${bestMatch.key.name.toUpperCase()}: ${bestMatch.value}점');
```

### 5. 차원별 강점 분석
```dart
final strengths = provider.getDimensionStrengths();
print('외향성: ${strengths['Extraversion']?.toStringAsFixed(1)}%');
print('내향성: ${strengths['Introversion']?.toStringAsFixed(1)}%');
```

### 6. 테스트 통계
```dart
final stats = await provider.getTestStatistics();
print('총 테스트 횟수: ${stats['totalTests']}');
print('평균 소요 시간: ${stats['averageDuration']}');
print('가장 많이 나온 유형: ${stats['mostFrequentType']}');
```

## 데이터 구조

### TestResult
테스트 결과를 담는 모델 클래스:
- `id`: 고유 식별자
- `completedAt`: 완료 시간
- `totalScores`: 총 점수 (MBTIScores)
- `resultType`: 결정된 MBTI 유형
- `mbtiResult`: 상세 결과 정보
- `answers`: 사용자 답변 목록
- `testDuration`: 테스트 소요 시간

### MBTIScores
8개 차원의 점수를 담는 클래스:
- `e`, `i`: 외향성/내향성
- `s`, `n`: 감각/직관
- `t`, `f`: 사고/감정
- `j`, `p`: 판단/인식

## 저장소 관리

### SharedPreferences 키
- `mbti_test_results`: 테스트 결과 히스토리 (최대 10개)
- `mbti_latest_result`: 최신 테스트 결과

### 데이터 삭제
```dart
await provider.clearAllResults(); // 모든 결과 삭제
```

## 에러 처리
Provider는 자동으로 에러를 처리하고 `error` 상태를 제공합니다:

```dart
Consumer<MBTIResultProvider>(
  builder: (context, provider, child) {
    if (provider.error != null) {
      return Text('오류: ${provider.error}');
    }
    
    if (provider.isLoading) {
      return CircularProgressIndicator();
    }
    
    // 정상 상태의 UI
    return YourWidget();
  },
)
```