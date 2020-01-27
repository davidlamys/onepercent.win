import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final _auth = FirebaseAuth.instance;

  Future<bool> hasLoggedInUser() async {
    final user = await _auth.currentUser();
    print('fetched user');
    return (user != null);
  }

  Future<String> userId() async {
    final user = await _auth.currentUser();
    if (user == null) {
      return null;
    }
    return user.uid;
  }

  Future<void> signOutUser() async {
    return _auth.signOut();
  }

  void logingInAnonymously() async {
    final result = await _auth.signInAnonymously();
  }
}
