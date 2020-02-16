import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Services/user_service.dart';

class GoalService {
  final _firestore = Firestore.instance;

  Future<Stream<List<Record>>> goalStream() async {
    final userId = await UserService().userId();
    print(userId);
    return _firestore
        .collection('dailyGoals')
        .orderBy("timestamp")
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      List<DocumentSnapshot> documents = snapshot.documents;

      return documents.map((e) => Record.fromSnapshot(e)).toList();
    });
  }

  Future<Void> addGoal(Goal goal) {
    return _firestore.collection('dailyGoals').add(goal.data()).then((value) {
      return;
    }, onError: (error) {
      return error;
    });
  }
}

class Goal {
  final String id;
  final String goal;
  final String reason;
  final DateTime date;
  final String createdBy;
  final String userId;
  final String notes;

  Goal(this.id, this.goal, this.reason, this.date, this.createdBy, this.userId,
      this.notes);

  factory(Record record) {}

  Map<String, dynamic> data() {
    return {
      "goal": goal,
      "reason": reason,
      "timestamp": date,
      "createdBy": createdBy,
      "userId": userId,
      "notes": notes,
    };
  }
}
