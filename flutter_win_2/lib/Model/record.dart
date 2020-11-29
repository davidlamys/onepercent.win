import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_win_2/Styling/colors.dart';

class Record {
  final String id;
  final String name;
  final String reason;
  final DateTime timestamp;
  final String userId;
  final String documentID;
  final String createdBy;
  final String notes;
  final String status;

  Record.fromMap(Map<String, dynamic> map, {this.documentID})
      : assert(map['goal'] != null),
        assert(map['reason'] != null),
        id = documentID,
        name = map['goal'],
        reason = map['reason'],
        timestamp = parseTime(map['timestamp']),
        userId = map['userId'],
        createdBy = map['createdBy'],
        notes = map['notes'],
        status = map['status'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, documentID: snapshot.reference.documentID);

  Record(
      String id,
      String name,
      String reason,
      DateTime timestamp,
      String userId,
      String documentID,
      String createdBy,
      String notes,
      String status)
      : id = id,
        name = name,
        reason = reason,
        timestamp = timestamp,
        userId = userId,
        documentID = documentID,
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
        this.documentID,
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

  bool hasFailed() => this.status == "failed";
  bool isInProgress() => this.status == "inProgress";
  bool isCompletedWithNotes() => this.status == "completedWithNotes";
}

DateTime parseTime(dynamic date) {
  if (date is DateTime) {
    return date;
  }
  return (date as Timestamp).toDate();
}

String getStatusPrompt(Record selectedRecord) {
  if (selectedRecord == null) {
    return "No Goals??";
  } else if (selectedRecord.isInProgress()) {
    return "You've got this!";
  } else if (selectedRecord.notes == null) {
    return "Reflection needed"; // legacy ui
  } else if (selectedRecord.isCompletedWithNotes()) {
    return "Good. Now aim higher";
  } else if (selectedRecord.hasFailed()) {
    return "Lesson Learnt";
  } else {
    return "Good. Now aim higher";
  }
}

Color getColor(Record selectedRecord) {
  if (selectedRecord == null) {
    return appRed;
  }
  if (selectedRecord.notes == null) {
    return appOrange;
  }

  return appGreen;
}

String getEmojiString(Record record) {
  if (record.status == null) {
    return "";
  }
  if (record.status == "completedWithNotes") {
    return " 😎 ";
  }
  if (record.status == "failed") {
    return " 🤔 ";
  }
  return " 🚧";
}
