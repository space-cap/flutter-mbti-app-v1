import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/models.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  final TestResult testResult;

  const ResultScreen({
    super.key,
    required this.testResult,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late AnimationController _progressAnimationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(const Duration(milliseconds: 300), () {
      _mainAnimationController.forward();
      _progressAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: AnimatedBuilder(
        animation: _mainAnimationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildTypeCard(),
                    const SizedBox(height: 32),
                    _buildScoreVisualization(),
                    const SizedBox(height: 32),
                    _buildActionButtons(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          '테스트 완료!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '당신의 MBTI 유형이 판정되었습니다',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeCard() {
    final mbtiResult = widget.testResult.mbtiResult;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.primaryContainer.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              mbtiResult.typeCode,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            mbtiResult.nickname,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            mbtiResult.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colorScheme.onPrimaryContainer.withOpacity(0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreVisualization() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '성향 분석',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _buildDimensionBars(),
      ],
    );
  }

  Widget _buildDimensionBars() {
    final percentages = widget.testResult.dimensionPercentages;
    final dimensions = [
      {'pair': 'E / I', 'left': 'E', 'right': 'I', 'leftLabel': '외향형', 'rightLabel': '내향형'},
      {'pair': 'S / N', 'left': 'S', 'right': 'N', 'leftLabel': '감각형', 'rightLabel': '직관형'},
      {'pair': 'T / F', 'left': 'T', 'right': 'F', 'leftLabel': '사고형', 'rightLabel': '감정형'},
      {'pair': 'J / P', 'left': 'J', 'right': 'P', 'leftLabel': '판단형', 'rightLabel': '인식형'},
    ];

    return Column(
      children: dimensions.map((dimension) {
        final leftPercent = percentages[dimension['left']] ?? 0.0;
        final rightPercent = percentages[dimension['right']] ?? 0.0;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: _buildDimensionBar(
            dimension['pair']!,
            dimension['left']!,
            dimension['right']!,
            dimension['leftLabel']!,
            dimension['rightLabel']!,
            leftPercent,
            rightPercent,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDimensionBar(
    String pair,
    String leftKey,
    String rightKey,
    String leftLabel,
    String rightLabel,
    double leftPercent,
    double rightPercent,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDominantLeft = leftPercent > rightPercent;
    final dominantPercent = isDominantLeft ? leftPercent : rightPercent;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              pair,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${dominantPercent.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                leftLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDominantLeft 
                    ? colorScheme.primary 
                    : colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: isDominantLeft ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            Expanded(
              child: Text(
                rightLabel,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: !isDominantLeft 
                    ? colorScheme.primary 
                    : colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: !isDominantLeft ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
          child: AnimatedBuilder(
            animation: _progressAnimationController,
            builder: (context, child) {
              final progress = _progressAnimationController.value;
              final animatedLeftPercent = leftPercent * progress;
              final animatedRightPercent = rightPercent * progress;
              
              return Row(
                children: [
                  Expanded(
                    flex: (animatedLeftPercent * 100).round(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDominantLeft 
                          ? colorScheme.primary 
                          : colorScheme.primary.withOpacity(0.3),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: (animatedRightPercent * 100).round(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: !isDominantLeft 
                          ? colorScheme.primary 
                          : colorScheme.primary.withOpacity(0.3),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _showDetailView,
            icon: const Icon(Icons.visibility),
            label: const Text('상세보기'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _retakeTest,
                icon: const Icon(Icons.refresh),
                label: const Text('다시 테스트'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _shareResult,
                icon: const Icon(Icons.share),
                label: const Text('공유하기'),
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
      ],
    );
  }

  void _showDetailView() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildDetailBottomSheet(),
    );
  }

  Widget _buildDetailBottomSheet() {
    final mbtiResult = widget.testResult.mbtiResult;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: colorScheme.surface,
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
              color: colorScheme.onSurface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          mbtiResult.typeCode,
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        Text(
                          mbtiResult.nickname,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailSection('상세 설명', mbtiResult.detailDescription),
                  const SizedBox(height: 24),
                  _buildDetailSection('강점', mbtiResult.strengths.join('\n• ')),
                  const SizedBox(height: 24),
                  _buildDetailSection('약점', mbtiResult.weaknesses.join('\n• ')),
                  const SizedBox(height: 24),
                  _buildDetailSection('적합한 직업', mbtiResult.careers.join(', ')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content.startsWith('•') ? '• $content' : content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.6,
          ),
        ),
      ],
    );
  }

  void _retakeTest() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  void _shareResult() {
    final mbtiResult = widget.testResult.mbtiResult;
    final shareText = '''
🎉 MBTI 테스트 결과 🎉

유형: ${mbtiResult.typeCode}
별칭: ${mbtiResult.nickname}

${mbtiResult.description}

#MBTI #성격검사 #${mbtiResult.typeCode}
''';
    
    Share.share(shareText);
  }
}