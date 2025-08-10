import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
import '../models/mbti_result.dart';

class ShareUtils {
  static const String _appDownloadLink = 'https://github.com/your-username/flutter-mbti-app';
  
  static Future<void> shareText(MBTIResult result) async {
    final text = _generateShareText(result);
    await Share.share(text);
  }
  
  static Future<void> shareImage(GlobalKey key, MBTIResult result) async {
    try {
      final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) return;
      
      final pngBytes = byteData.buffer.asUint8List();
      final text = _generateShareText(result);
      
      await Share.shareXFiles(
        [XFile.fromData(pngBytes, name: 'mbti_result_${result.typeCode.toLowerCase()}.png', mimeType: 'image/png')],
        text: text,
      );
    } catch (e) {
      debugPrint('Error sharing image: $e');
    }
  }
  
  static String _generateShareText(MBTIResult result) {
    return '''🧠 MBTI 테스트 결과 🧠

${result.typeCode} - ${result.title}
"${result.nickname}"

${result.description}

💪 주요 강점:
${result.strengths.take(3).map((s) => '• $s').join('\n')}

🎯 추천 직업:
${result.careers.take(3).map((c) => '• $c').join('\n')}

나도 MBTI 테스트 해보기! 👇
$_appDownloadLink

#MBTI #성격테스트 #${result.typeCode}''';
  }
  
  static Widget createShareableWidget(MBTIResult result) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getTypeColor(result.type).withOpacity(0.8),
            _getTypeColor(result.type).withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MBTI 테스트 결과',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    result.typeCode,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: _getTypeColor(result.type),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  result.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '"${result.nickname}"',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            result.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '💪 주요 강점',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                ...result.strengths.take(3).map(
                  (strength) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• $strength',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🎯 추천 직업',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                ...result.careers.take(3).map(
                  (career) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• $career',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '나도 MBTI 테스트 해보기!',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getTypeColor(result.type),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  static Color _getTypeColor(MBTIType type) {
    switch (type) {
      case MBTIType.entj:
      case MBTIType.estj:
        return const Color(0xFF8B5A2B);
      case MBTIType.enfj:
      case MBTIType.esfj:
        return const Color(0xFF0F7B0F);
      case MBTIType.entp:
      case MBTIType.estp:
        return const Color(0xFFE91E63);
      case MBTIType.enfp:
      case MBTIType.esfp:
        return const Color(0xFFFF9800);
      case MBTIType.intj:
      case MBTIType.istj:
        return const Color(0xFF6A4C93);
      case MBTIType.infj:
      case MBTIType.isfj:
        return const Color(0xFF1976D2);
      case MBTIType.intp:
      case MBTIType.istp:
        return const Color(0xFF37474F);
      case MBTIType.infp:
      case MBTIType.isfp:
        return const Color(0xFF4CAF50);
    }
  }
}