import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final String name;
  final String reason;
  final DateTime timestamp;
  final DocumentReference reference;
  final String notes;
  final String status;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['goal'] != null),
        assert(map['reason'] != null),
        name = map['goal'],
        reason = map['reason'],
        timestamp = parseTime(map['timestamp']),
        notes = map['notes'],
        status = map['status'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}

DateTime parseTime(dynamic date) {
  if (date is DateTime) {
    return date;
  }
  return (date as Timestamp).toDate();
}
