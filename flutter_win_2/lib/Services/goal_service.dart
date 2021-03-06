import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Services/user_service.dart';

class FakeGoalService extends GoalService {
  StreamController<List<Record>> stubGoalsStreamController =
      StreamController<List<Record>>();
  List<Record> _list = List.from([], growable: true);

  FakeGoalService() {
    _list.add(build());
    stubGoalsStreamController.stream.asBroadcastStream().listen((event) {
      print("new value in stub");
      _list = event;
    });
  }

  Record build() {
    var map = Map<String, dynamic>();
    map['documentID'] = "hello";
    map['goal'] = "Something";
    map['reason'] = "big and strong";
    map['timestamp'] = DateTime.now();
    map['notes'] = "some notes";
    return Record.fromMap(map, documentID: "some  ID");
  }

  @override
  Future<Stream<List<Record>>> goalStream() {
    return Future.value(stubGoalsStreamController.stream.asBroadcastStream());
  }

  @override
  Future<void> addGoal(Goal goal) async {
    final data = goal.data();
    final newRecord = Record.fromMap(data);
    _list.add(newRecord);
    stubGoalsStreamController.add(_list);
    print(
        "add new goal in stub $newRecord with timeStamp: ${newRecord.timestamp}");
    await Future.delayed(Duration(seconds: 1));
  }
}

class GoalService {
  final _firestore = Firestore.instance;

  Future<Stream<List<Record>>> goalStream() async {
    final userId = await UserService().userId();
    print("setting up goal stream with userId: $userId");
    return _firestore
        .collection('dailyGoals')
        .orderBy("timestamp")
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      List<DocumentSnapshot> documents = snapshot.documents;
      print("received: ${documents.length}");
      return documents.map((e) => Record.fromSnapshot(e)).toList();
    });
  }

  Stream<List<Record>> globalGoalsStream() {
    return _firestore
        .collection('dailyGoals')
        .orderBy("timestamp", descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      List<DocumentSnapshot> documents = snapshot.documents;
      print("received: ${documents.length}");
      return documents.reversed.map((e) => Record.fromSnapshot(e)).toList();
    });
  }

  Future<void> addGoal(Goal goal) {
    return _firestore.collection('dailyGoals').add(goal.data()).then((value) {
      return;
    }, onError: (error) {
      return error;
    });
  }

  Future<void> update(Record record) {
    print("updating record with id: ${record.id}");
    return _firestore
        .collection('dailyGoals')
        .document(record.id)
        .updateData(record.data())
        .then((value) {
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
  final String status;

  Goal(this.id, this.goal, this.reason, this.date, this.createdBy, this.userId,
      this.notes, this.status);

  Map<String, dynamic> data() {
    return {
      "goal": goal,
      "reason": reason,
      "timestamp": date,
      "createdBy": createdBy,
      "userId": userId,
      "notes": notes,
      "status": status
    };
  }
}
