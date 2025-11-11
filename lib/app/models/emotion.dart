enum EmotionLevel {
  veryUnhappy(1, 'Very Unhappy', '😢'),
  unhappy(2, 'Unhappy', '😞'),
  neutral(3, 'Neutral', '😐'),
  happy(4, 'Happy', '😊'),
  veryHappy(5, 'Very Happy', '🤑');

  final int value;
  final String label;
  final String emoji;

  const EmotionLevel(this.value, this.label, this.emoji);

  static EmotionLevel fromValue(int value) {
    return EmotionLevel.values.firstWhere(
      (level) => level.value == value,
      orElse: () => EmotionLevel.neutral,
    );
  }
}

class Emotion {
  final EmotionLevel level;
  final String? note;

  const Emotion({required this.level, this.note});

  Map<String, dynamic> toJson() {
    return {'level': level.value, 'note': note};
  }

  factory Emotion.fromJson(Map<String, dynamic> json) {
    return Emotion(
      level: EmotionLevel.fromValue(json['level'] as int),
      note: json['note'] as String?,
    );
  }

  Emotion copyWith({EmotionLevel? level, String? note}) {
    return Emotion(level: level ?? this.level, note: note ?? this.note);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Emotion && other.level == level && other.note == note;
  }

  @override
  int get hashCode => level.hashCode ^ note.hashCode;
}
