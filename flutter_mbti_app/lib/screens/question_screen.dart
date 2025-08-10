import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/question.dart';
import '../models/test_result.dart';
import '../utils/mbti_result_provider.dart';
import '../utils/error_handler.dart';
import '../widgets/loading_widget.dart';
import 'result_screen.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  List<UserAnswer> answers = [];
  DateTime? testStartTime;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    testStartTime = DateTime.now();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final String response = await rootBundle.loadString('assets/data/questions.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        questions = data.map((json) => Question.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ErrorHandler.showErrorSnackBar(
          context,
          '질문을 로드하는데 실패했습니다: ${ErrorHandler.getErrorMessage(e)}',
        );
      }
    }
  }

  void _selectAnswer(QuestionOption selectedOption, String optionKey) {
    final answer = UserAnswer(
      questionId: questions[currentQuestionIndex].id,
      selectedOption: optionKey,
      contributedScores: selectedOption.scores,
      answeredAt: DateTime.now(),
    );
    
    setState(() {
      answers.add(answer);
    });

    if (currentQuestionIndex + 1 >= questions.length) {
      _showTestCompleted();
    } else {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void _showTestCompleted() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('테스트 완료!'),
          content: const Text('모든 질문에 답변하셨습니다.\n결과를 확인해보세요.'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                await _navigateToResult();
              },
              child: const Text('결과 보기'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToResult() async {
    if (!mounted) return;
    
    try {
      // Show loading indicator
      ErrorHandler.showLoadingDialog(
        context,
        message: '결과를 계산하고 있어요...',
      );

      final provider = context.read<MBTIResultProvider>();
      
      // Calculate and save test result using provider
      await provider.calculateAndSaveResult(
        answers: answers,
        startTime: testStartTime!,
        endTime: DateTime.now(),
      );

      // Close loading indicator
      if (mounted) {
        ErrorHandler.hideLoadingDialog(context);
        
        // Show success message briefly
        ErrorHandler.showSuccessSnackBar(
          context,
          '결과가 성공적으로 저장되었습니다!',
          duration: const Duration(seconds: 2),
        );
        
        // Navigate to result screen after brief delay
        await Future.delayed(const Duration(milliseconds: 800));
        
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                testResult: provider.currentResult!,
              ),
            ),
          );
        }
      }
    } catch (e) {
      // Close loading indicator
      if (mounted) {
        ErrorHandler.hideLoadingDialog(context);
        
        // Show error
        ErrorHandler.showErrorSnackBar(
          context,
          '결과를 계산하는데 실패했습니다: ${ErrorHandler.getErrorMessage(e)}',
        );
      }
    }
  }

  void _goBack() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        // Remove the last answer
        if (answers.isNotEmpty) {
          answers.removeLast();
        }
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('MBTI 테스트'),
          backgroundColor: Colors.transparent,
        ),
        body: const LoadingWidget(
          message: '질문을 준비하고 있어요...',
          size: 48,
        ),
      );
    }

    if (questions.isEmpty || currentQuestionIndex >= questions.length) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('MBTI 테스트'),
          backgroundColor: Colors.transparent,
        ),
        body: ErrorHandler.buildErrorWidget(
          message: '질문을 로드할 수 없습니다.',
          onRetry: _loadQuestions,
        ),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: _goBack,
        ),
        title: Text(
          'MBTI 테스트',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Progress indicator
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${currentQuestionIndex + 1}/${questions.length}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF9C88FF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF9C88FF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Progress bar
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE8E3FF),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF9C88FF),
                    ),
                  ),
                ),
              ),

              // Question card
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9C88FF).withOpacity(0.1),
                        offset: const Offset(0, 8),
                        blurRadius: 24,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Question text
                      Container(
                        margin: const EdgeInsets.only(bottom: 40),
                        child: Text(
                          currentQuestion.text,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Answer options
                      Column(
                        children: [
                          // Option A
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _selectAnswer(currentQuestion.optionA, 'A'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFF2F8),
                                foregroundColor: const Color(0xFF8B5A83),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(
                                    color: Color(0xFFE8B3D1),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Text(
                                currentQuestion.optionA.text,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                          // Option B
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _selectAnswer(currentQuestion.optionB, 'B'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF0F8FF),
                                foregroundColor: const Color(0xFF5A7B8B),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(
                                    color: Color(0xFFB3D1E8),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Text(
                                currentQuestion.optionB.text,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}