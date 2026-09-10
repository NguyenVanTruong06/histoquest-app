import 'historical_event_model.dart';

class EraModel {
  final String id;
  final String name;
  final String centuryTitle;
  final String timelineSpan;
  final String description;
  final bool isUnlocked;
  final List<HistoricalEventModel> events;

  const EraModel({
    required this.id,
    required this.name,
    required this.centuryTitle,
    required this.timelineSpan,
    required this.description,
    this.isUnlocked = true,
    this.events = const [],
  });

  int get totalEvents => events.length;
  int get completedEvents => events.where((e) => e.isCompleted).length;
  double get progress => totalEvents == 0 ? 0.0 : (completedEvents / totalEvents);

  EraModel copyWith({
    String? id,
    String? name,
    String? centuryTitle,
    String? timelineSpan,
    String? description,
    bool? isUnlocked,
    List<HistoricalEventModel>? events,
  }) {
    return EraModel(
      id: id ?? this.id,
      name: name ?? this.name,
      centuryTitle: centuryTitle ?? this.centuryTitle,
      timelineSpan: timelineSpan ?? this.timelineSpan,
      description: description ?? this.description,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      events: events ?? this.events,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'centuryTitle': centuryTitle,
      'timelineSpan': timelineSpan,
      'description': description,
      'isUnlocked': isUnlocked,
      'events': events.map((e) => e.toJson()).toList(),
    };
  }

  factory EraModel.fromJson(Map<String, dynamic> json) {
    return EraModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      centuryTitle: json['centuryTitle'] as String? ?? '',
      timelineSpan: json['timelineSpan'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isUnlocked: json['isUnlocked'] as bool? ?? true,
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => HistoricalEventModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
