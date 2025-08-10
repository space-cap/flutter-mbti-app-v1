import 'package:flutter/material.dart';
import 'question_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasStoredResults = false; // 추후 실제 데이터로 연동

  @override
  void initState() {
    super.initState();
    // 추후 SharedPreferences나 다른 저장소에서 이전 결과 확인
    _checkStoredResults();
  }

  void _checkStoredResults() {
    // TODO: 실제 저장된 결과 확인 로직 구현
    // 임시로 false로 설정
    setState(() {
      hasStoredResults = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // 상단 여백
              const SizedBox(height: 40),
              
              // 앱 로고/아이콘
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primaryContainer,
                ),
                child: Icon(
                  Icons.psychology_outlined,
                  size: 60,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // 앱 제목
              Text(
                'MBTI 성격 유형 테스트',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // 소개 텍스트
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '16가지 성격 유형 중 나만의 특별한 유형을 찾아보세요.\n'
                  '간단한 질문들을 통해 당신의 성격을 분석해드립니다.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // 중앙 여백을 위한 Expanded
              const Expanded(child: SizedBox()),
              
              // 버튼들
              Column(
                children: [
                  // 테스트 시작 버튼
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const QuestionScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text(
                        '테스트 시작',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 이전 결과 보기 버튼 (조건부 표시)
                  if (hasStoredResults)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: 결과 화면으로 이동
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('결과 화면 구현 예정'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.history),
                        label: const Text(
                          '이전 결과 보기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}