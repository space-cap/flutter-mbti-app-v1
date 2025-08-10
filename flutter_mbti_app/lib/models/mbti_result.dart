enum MBTIType {
  entj,
  enfj,
  entp,
  enfp,
  estj,
  esfj,
  estp,
  esfp,
  intj,
  infj,
  intp,
  infp,
  istj,
  isfj,
  istp,
  isfp,
}

class MBTIResult {
  final MBTIType type;
  final String title;
  final String nickname;
  final String description;
  final String detailDescription;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> careers;
  final List<MBTIType> compatibleTypes;

  const MBTIResult({
    required this.type,
    required this.title,
    required this.nickname,
    required this.description,
    required this.detailDescription,
    required this.strengths,
    required this.weaknesses,
    required this.careers,
    required this.compatibleTypes,
  });

  String get typeCode {
    return type.name.toUpperCase();
  }

  factory MBTIResult.fromJson(Map<String, dynamic> json) {
    return MBTIResult(
      type: MBTIType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      title: json['title'] as String,
      nickname: json['nickname'] as String,
      description: json['description'] as String,
      detailDescription: json['detailDescription'] as String,
      strengths: List<String>.from(json['strengths'] as List),
      weaknesses: List<String>.from(json['weaknesses'] as List),
      careers: List<String>.from(json['careers'] as List),
      compatibleTypes: (json['compatibleTypes'] as List)
          .map((e) => MBTIType.values.firstWhere((type) => type.name == e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'title': title,
      'nickname': nickname,
      'description': description,
      'detailDescription': detailDescription,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'careers': careers,
      'compatibleTypes': compatibleTypes.map((e) => e.name).toList(),
    };
  }

  static MBTIType calculateType(int eScore, int iScore, int sScore, int nScore, 
                               int tScore, int fScore, int jScore, int pScore) {
    final extroversion = eScore > iScore;
    final sensing = sScore > nScore;
    final thinking = tScore > fScore;
    final judging = jScore > pScore;

    final typeString = '${extroversion ? 'e' : 'i'}'
        '${sensing ? 's' : 'n'}'
        '${thinking ? 't' : 'f'}'
        '${judging ? 'j' : 'p'}';

    return MBTIType.values.firstWhere(
      (type) => type.name == typeString,
    );
  }
}