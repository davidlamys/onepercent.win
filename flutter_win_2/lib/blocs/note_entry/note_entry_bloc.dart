import 'dart:async';

import 'package:flutter_win_2/Model/record.dart';
import 'package:rxdart/rxdart.dart';

import '../../service_factory.dart';

class NoteEntryBloc {
  final _goalService = ServiceFactory.getGoalService();

  Record record;
  BehaviorSubject<String> _notes = BehaviorSubject.seeded(null);
  BehaviorSubject<bool> _isSaveEnabled = BehaviorSubject.seeded(false);
  Stream<bool> get isSaveEnabled => _isSaveEnabled.stream;

  NoteEntryBloc() {
    _notes.map((note) {
      if (note == null) {
        return false;
      }
      return note.trim() != "";
    }).pipe(_isSaveEnabled);
  }

  Future<void> save() async {
    final clone = record.copyWith(notes: _notes.value.trim());
    return _goalService.update(clone);
  }

  setRecord(Record record) {
    this.record = record;
    if (record == null) {
      _notes.sink.add(null);
    } else {
      _notes.sink.add(record.notes);
    }
  }

  setNote(String note) {
    _notes.sink.add(note);
  }

  dispose() {
    _isSaveEnabled.close();
    _notes.close();
  }
}
