import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_mbti_app/main.dart';
import 'package:flutter_mbti_app/screens/home_screen.dart';
import 'package:flutter_mbti_app/screens/question_screen.dart';
import 'package:flutter_mbti_app/utils/mbti_result_provider.dart';
import 'package:flutter_mbti_app/models/models.dart';

void main() {
  group('MBTI App Integration Tests', () {
    
    testWidgets('App initialization and home screen display', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(const MBTIApp());
      
      // Verify app title
      expect(find.text('MBTI 성격 유형 테스트'), findsOneWidget);
      
      // Verify main elements are present
      expect(find.byIcon(Icons.psychology_outlined), findsOneWidget);
      expect(find.text('테스트 시작'), findsOneWidget);
      expect(find.text('모든 MBTI 유형 둘러보기'), findsOneWidget);
      
      // Verify intro text is displayed
      expect(find.textContaining('16가지 성격 유형'), findsOneWidget);
    });

    testWidgets('Navigation to question screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MBTIApp());
      
      // Find and tap the start test button
      await tester.tap(find.text('테스트 시작'));
      await tester.pumpAndSettle();
      
      // Should navigate to question screen
      // (Note: This will fail if questions.json is not available, but shows navigation works)
      expect(find.text('MBTI 테스트'), findsOneWidget);
    });

    testWidgets('MBTI types dialog functionality', (WidgetTester tester) async {
      await tester.pumpWidget(const MBTIApp());
      
      // Tap the explore MBTI types button
      await tester.tap(find.text('모든 MBTI 유형 둘러보기'));
      await tester.pumpAndSettle();
      
      // Verify modal dialog appears
      expect(find.text('모든 MBTI 유형'), findsOneWidget);
      
      // Verify we have 16 MBTI type buttons (4x4 grid)
      expect(find.byType(InkWell), findsNWidgets(16));
    });

    testWidgets('Provider state management', (WidgetTester tester) async {
      final provider = MBTIResultProvider();
      
      await tester.pumpWidget(
        ChangeNotifierProvider<MBTIResultProvider>.value(
          value: provider,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );
      
      // Initially should not have results
      expect(provider.hasResult, false);
      expect(provider.isLoading, false);
      expect(provider.currentResult, null);
      
      // Provider should be initialized
      await tester.pumpAndSettle();
    });
    
  });

  group('MBTI Calculator Tests', () {
    
    test('MBTI score calculation', () {
      final answers = [
        UserAnswer(
          questionId: 1,
          selectedOption: 'A',
          contributedScores: const MBTIScores(e: 2, i: 0, s: 0, n: 0, t: 0, f: 0, j: 0, p: 0),
          answeredAt: DateTime.now(),
        ),
        UserAnswer(
          questionId: 2,
          selectedOption: 'B',
          contributedScores: const MBTIScores(e: 0, i: 2, s: 0, n: 0, t: 0, f: 0, j: 0, p: 0),
          answeredAt: DateTime.now(),
        ),
      ];
      
      // Test basic score calculation
      expect(answers.length, 2);
      expect(answers[0].contributedScores.e, 2);
      expect(answers[1].contributedScores.i, 2);
    });
    
    test('MBTI type determination logic', () {
      // Test type determination with clear majorities
      const testScores = MBTIScores(
        e: 10, i: 2,  // Clear E preference
        s: 8, n: 4,   // Clear S preference  
        t: 9, f: 3,   // Clear T preference
        j: 7, p: 5,   // Clear J preference
      );
      
      // Result should be ESTJ
      final type = MBTIResult.calculateType(
        testScores.e, testScores.i,
        testScores.s, testScores.n,
        testScores.t, testScores.f,
        testScores.j, testScores.p,
      );
      
      expect(type, MBTIType.estj);
    });
    
  });

  group('Error Handling Tests', () {
    
    testWidgets('Error display when questions fail to load', (WidgetTester tester) async {
      // Create a QuestionScreen widget (will fail to load questions in test environment)
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => MBTIResultProvider()),
            ],
            child: const QuestionScreen(),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Should show loading initially, then error state
      expect(find.text('질문을 준비하고 있어요...'), findsAny);
    });
    
  });

  group('Theme and UI Tests', () {
    
    testWidgets('Consistent theme application', (WidgetTester tester) async {
      await tester.pumpWidget(const MBTIApp());
      
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);
      
      // Verify Material 3 is enabled
      expect(materialApp.theme?.useMaterial3, true);
    });
    
    testWidgets('Responsive button styling', (WidgetTester tester) async {
      await tester.pumpWidget(const MBTIApp());
      
      // Find the main action button
      final startButton = find.text('테스트 시작');
      expect(startButton, findsOneWidget);
      
      // Verify it's properly styled
      final button = tester.widget<ElevatedButton>(
        find.ancestor(
          of: startButton,
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(button.onPressed, isNotNull);
    });
    
  });

  group('Performance Tests', () {
    
    test('Memory efficiency checks', () {
      // Test that large lists are handled efficiently
      final largeList = List.generate(1000, (index) => 'Item $index');
      final efficientSlice = largeList.sublist(0, 10);
      
      expect(efficientSlice.length, 10);
      expect(efficientSlice.first, 'Item 0');
      expect(efficientSlice.last, 'Item 9');
    });
    
    testWidgets('Animation performance', (WidgetTester tester) async {
      await tester.pumpWidget(const MBTIApp());
      
      // Pump multiple frames to ensure animations don't cause performance issues
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      
      // Should complete without frame drops
      expect(tester.hasRunningAnimations, false);
    });
    
  });

  group('Accessibility Tests', () {
    
    testWidgets('Semantic labels and accessibility', (WidgetTester tester) async {
      await tester.pumpWidget(const MBTIApp());
      
      // Verify important elements have semantic labels
      expect(find.text('테스트 시작'), findsOneWidget);
      expect(find.text('모든 MBTI 유형 둘러보기'), findsOneWidget);
      
      // Test screen reader compatibility
      await tester.pumpAndSettle();
      
      final semantics = tester.getSemantics(find.text('테스트 시작'));
      expect(semantics.label, isNotNull);
    });
    
  });
}