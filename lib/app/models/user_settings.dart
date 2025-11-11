class UserSettings {
  final String userId;
  final String currency;
  final String currencySymbol;
  final bool isDarkMode;
  final bool notificationsEnabled;
  final String language;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserSettings({
    required this.userId,
    this.currency = 'USD',
    this.currencySymbol = '\$',
    this.isDarkMode = false,
    this.notificationsEnabled = true,
    this.language = 'en',
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currency': currency,
      'currencySymbol': currencySymbol,
      'isDarkMode': isDarkMode,
      'notificationsEnabled': notificationsEnabled,
      'language': language,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      userId: json['userId'] as String,
      currency: json['currency'] as String? ?? 'USD',
      currencySymbol: json['currencySymbol'] as String? ?? '\$',
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  UserSettings copyWith({
    String? userId,
    String? currency,
    String? currencySymbol,
    bool? isDarkMode,
    bool? notificationsEnabled,
    String? language,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserSettings(
      userId: userId ?? this.userId,
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserSettings && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}
