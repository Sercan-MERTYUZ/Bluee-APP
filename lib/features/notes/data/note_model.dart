import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 2)
class Note extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String content;

  @HiveField(2)
  String person;

  @HiveField(3)
  DateTime createdAt;

  Note({
    required this.id,
    required this.content,
    required this.person,
    required this.createdAt,
  });

  Note copyWith({
    String? id,
    String? content,
    String? person,
    DateTime? createdAt,
  }) {
    return Note(
      id: id ?? this.id,
      content: content ?? this.content,
      person: person ?? this.person,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
