class UserModel {
  final String id;
  final String name;
  final int level;
  final String title;
  final int streakDays;
  final int coins;
  final int xp;
  final int totalQuestsCompleted;
  final String? avatarUrl;
  final String currentBannerId;
  final String currentFrameId;
  final List<String> unlockedDecorationIds;

  const UserModel({
    required this.id,
    required this.name,
    this.level = 1,
    this.title = 'Tân thủ',
    this.streakDays = 0,
    this.coins = 0,
    this.xp = 0,
    this.totalQuestsCompleted = 0,
    this.avatarUrl,
    this.currentBannerId = 'banner_default',
    this.currentFrameId = 'frame_default',
    this.unlockedDecorationIds = const ['frame_default', 'banner_default'],
  });

  UserModel copyWith({
    String? id,
    String? name,
    int? level,
    String? title,
    int? streakDays,
    int? coins,
    int? xp,
    int? totalQuestsCompleted,
    String? avatarUrl,
    String? currentBannerId,
    String? currentFrameId,
    List<String>? unlockedDecorationIds,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      title: title ?? this.title,
      streakDays: streakDays ?? this.streakDays,
      coins: coins ?? this.coins,
      xp: xp ?? this.xp,
      totalQuestsCompleted: totalQuestsCompleted ?? this.totalQuestsCompleted,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      currentBannerId: currentBannerId ?? this.currentBannerId,
      currentFrameId: currentFrameId ?? this.currentFrameId,
      unlockedDecorationIds: unlockedDecorationIds ?? this.unlockedDecorationIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'title': title,
      'streakDays': streakDays,
      'coins': coins,
      'xp': xp,
      'totalQuestsCompleted': totalQuestsCompleted,
      'avatarUrl': avatarUrl,
      'currentBannerId': currentBannerId,
      'currentFrameId': currentFrameId,
      'unlockedDecorationIds': unlockedDecorationIds,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Khách',
      level: json['level'] as int? ?? 1,
      title: json['title'] as String? ?? 'Tân thủ',
      streakDays: json['streakDays'] as int? ?? 0,
      coins: json['coins'] as int? ?? 0,
      xp: json['xp'] as int? ?? 0,
      totalQuestsCompleted: json['totalQuestsCompleted'] as int? ?? 0,
      avatarUrl: json['avatarUrl'] as String?,
      currentBannerId: json['currentBannerId'] as String? ?? 'banner_default',
      currentFrameId: json['currentFrameId'] as String? ?? 'frame_default',
      unlockedDecorationIds: (json['unlockedDecorationIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['frame_default', 'banner_default'],
    );
  }
}
