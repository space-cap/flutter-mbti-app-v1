import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/mbti_calculator.dart';

class MBTIDetailScreen extends StatelessWidget {
  final MBTIType mbtiType;

  const MBTIDetailScreen({
    super.key,
    required this.mbtiType,
  });

  @override
  Widget build(BuildContext context) {
    final mbtiResult = MBTICalculator.getMBTIResult(mbtiType);

    return Scaffold(
      appBar: AppBar(
        title: Text(mbtiResult.typeCode),
        backgroundColor: _getTypeColor(mbtiType),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(mbtiResult),
            const SizedBox(height: 24),
            _buildDescription(mbtiResult),
            const SizedBox(height: 24),
            _buildCharacteristics(mbtiResult),
            const SizedBox(height: 24),
            _buildStrengthsAndWeaknesses(mbtiResult),
            const SizedBox(height: 24),
            _buildCareers(mbtiResult),
            const SizedBox(height: 24),
            _buildCompatibility(mbtiResult),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(MBTIResult result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getTypeColor(result.type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getTypeColor(result.type).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _getTypeColor(result.type),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                result.typeCode,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            result.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            result.nickname,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(MBTIResult result) {
    return _buildSection(
      title: '상세 설명',
      icon: Icons.description,
      child: Text(
        result.detailDescription,
        style: const TextStyle(
          fontSize: 16,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildCharacteristics(MBTIResult result) {
    return _buildSection(
      title: '주요 특징',
      icon: Icons.star,
      child: Text(
        result.description,
        style: const TextStyle(
          fontSize: 16,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildStrengthsAndWeaknesses(MBTIResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          title: '강점',
          icon: Icons.thumb_up,
          child: Column(
            children: result.strengths.map((strength) => 
              _buildListItem(strength, Colors.green)
            ).toList(),
          ),
        ),
        const SizedBox(height: 16),
        _buildSection(
          title: '개선점',
          icon: Icons.trending_up,
          child: Column(
            children: result.weaknesses.map((weakness) => 
              _buildListItem(weakness, Colors.orange)
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCareers(MBTIResult result) {
    return _buildSection(
      title: '어울리는 직업군',
      icon: Icons.work,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: result.careers.map((career) => 
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getTypeColor(result.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _getTypeColor(result.type).withOpacity(0.3),
              ),
            ),
            child: Text(
              career,
              style: TextStyle(
                fontSize: 14,
                color: _getTypeColor(result.type),
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ).toList(),
      ),
    );
  }

  Widget _buildCompatibility(MBTIResult result) {
    return _buildSection(
      title: '궁합이 좋은 유형',
      icon: Icons.favorite,
      child: Column(
        children: result.compatibleTypes.map((type) {
          final compatibleResult = MBTICalculator.getMBTIResult(type);
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
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
                      compatibleResult.typeCode,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        compatibleResult.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        compatibleResult.nickname,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: _getTypeColor(mbtiType)),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildListItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8, right: 12),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
        ],
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