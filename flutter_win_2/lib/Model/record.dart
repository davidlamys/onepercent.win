import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final String id;
  final String name;
  final String reason;
  final DateTime timestamp;
  final String userId;
  final DocumentReference reference;
  final String createdBy;
  final String notes;
  final String status;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['goal'] != null),
        assert(map['reason'] != null),
        id = reference.documentID,
        name = map['goal'],
        reason = map['reason'],
        timestamp = parseTime(map['timestamp']),
        userId = map['userId'],
        createdBy = map['createdBy'],
        notes = map['notes'],
        status = map['status'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Record(
      String id,
      String name,
      String reason,
      DateTime timestamp,
      String userId,
      DocumentReference reference,
      String createdBy,
      String notes,
      String status)
      : id = id,
        name = name,
        reason = reason,
        timestamp = timestamp,
        userId = userId,
        reference = reference,
        createdBy = createdBy,
        notes = notes,
        status = status;

  Record copyWith({
    String goal,
    String reason,
    String notes,
    String status,
  }) {
    return Record(
        this.id,
        goal ?? this.name,
        reason ?? this.reason,
        this.timestamp,
        this.userId,
        this.reference,
        this.createdBy,
        notes ?? this.notes,
        status ?? this.status);
  }

  Map<String, dynamic> data() {
    return {
      "goal": name,
      "reason": reason,
      "timestamp": timestamp,
      "createdBy": createdBy,
      "userId": userId,
      "notes": notes,
      "status": status
    };
  }
}

DateTime parseTime(dynamic date) {
  if (date is DateTime) {
    return date;
  }
  return (date as Timestamp).toDate();
}

String getStatusPrompt(Record selectedRecord) {
  if (selectedRecord == null) {
    return "👀 No Goals?? 👀";
  } else if (selectedRecord.status == "inProgress") {
    return "💪 You've got this!! 💪";
  } else if (selectedRecord.notes == null) {
    return "🤔 Reflection needed!! 🤔";
  } else if (selectedRecord.status == "completedWithNotes") {
    return "🌈 Well done! Now aim again!! 🌈";
  } else {
    return "🌱 Lesson Learnt 🌱";
  }
}
