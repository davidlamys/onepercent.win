import 'package:flutter/widgets.dart';
import 'note_entry_bloc.dart';
export 'note_entry_bloc.dart';

class NoteEntryProvider extends InheritedWidget {
  NoteEntryProvider({Key key, this.child}) : super(key: key, child: child);

  final bloc = NoteEntryBloc();
  final Widget child;

  static NoteEntryProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NoteEntryProvider>();
  }

  @override
  bool updateShouldNotify(NoteEntryProvider oldWidget) {
    return true;
  }
}
