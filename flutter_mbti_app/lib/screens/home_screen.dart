import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'question_screen.dart';
import 'result_screen.dart';
import 'detail_screen.dart';
import '../utils/mbti_result_provider.dart';
import '../utils/performance_helper.dart';
import '../models/models.dart';
import '../widgets/animated_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    PerformanceHelper.watchForMemoryLeaks('HomeScreen');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PerformanceHelper.startTimer('InitializeProvider');
      context.read<MBTIResultProvider>().initialize().then((_) {
        PerformanceHelper.endTimer('InitializeProvider');
      });
    });
  }

  @override
  void dispose() {
    PerformanceHelper.stopWatchingMemoryLeaks('HomeScreen');
    super.dispose();
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
              
              // 앱 로고/아이콘 (애니메이션 적용)
              ScaleInAnimation(
                delay: const Duration(milliseconds: 200),
                child: PulseAnimation(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primaryContainer,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.psychology_outlined,
                      size: 60,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // 앱 제목 (애니메이션 적용)
              FadeInSlideUp(
                delay: const Duration(milliseconds: 400),
                child: Text(
                  'MBTI 성격 유형 테스트',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 소개 텍스트 (애니메이션 적용)
              FadeInSlideUp(
                delay: const Duration(milliseconds: 600),
                child: Padding(
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
              ),
              
              // 중앙 여백을 위한 Expanded
              const Expanded(child: SizedBox()),
              
              // 버튼들
              Column(
                children: [
                  // 테스트 시작 버튼 (글로우 효과 적용)
                  FadeInSlideUp(
                    delay: const Duration(milliseconds: 800),
                    child: SizedBox(
                      width: double.infinity,
                      child: GlowingButton(
                        onPressed: () {
                          PerformanceHelper.startTimer('NavigateToTest');
                          Navigator.of(context).push(
                            CustomPageRoute(
                              child: const QuestionScreen(),
                            ),
                          ).then((_) {
                            PerformanceHelper.endTimer('NavigateToTest');
                          });
                        },
                        glowColor: theme.colorScheme.primary,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow, size: 20),
                            SizedBox(width: 8),
                            Text(
                              '테스트 시작',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 이전 결과 보기 버튼 (조건부 표시)
                  Consumer<MBTIResultProvider>(
                    builder: (context, provider, child) {
                      if (provider.hasResult) {
                        return FadeInSlideUp(
                          delay: const Duration(milliseconds: 1000),
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      CustomPageRoute(
                                        child: ResultScreen(
                                          testResult: provider.currentResult!,
                                        ),
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
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      CustomPageRoute(
                                        child: MBTIDetailScreen(
                                          mbtiType: provider.currentResult!.resultType,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.info_outline),
                                  label: const Text('내 MBTI 상세보기'),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  // MBTI 유형 둘러보기 버튼
                  FadeInSlideUp(
                    delay: const Duration(milliseconds: 1200),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            onPressed: () => _showMBTITypesDialog(),
                            icon: const Icon(Icons.explore),
                            label: const Text('모든 MBTI 유형 둘러보기'),
                          ),
                        ),
                      ],
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

  void _showMBTITypesDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                '모든 MBTI 유형',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: MBTIType.values.map((type) {
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MBTIDetailScreen(mbtiType: type),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getTypeColor(type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getTypeColor(type).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _getTypeColor(type),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                type.name.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(MBTIType type) {
    switch (type) {
      case MBTIType.entj:
      case MBTIType.enfj:
      case MBTIType.entp:
      case MBTIType.enfp:
        return Colors.red;
      case MBTIType.estj:
      case MBTIType.esfj:
      case MBTIType.estp:
      case MBTIType.esfp:
        return Colors.blue;
      case MBTIType.intj:
      case MBTIType.infj:
      case MBTIType.intp:
      case MBTIType.infp:
        return Colors.purple;
      case MBTIType.istj:
      case MBTIType.isfj:
      case MBTIType.istp:
      case MBTIType.isfp:
        return Colors.green;
    }
  }
}