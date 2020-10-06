import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

final _auth = FirebaseAuth.instance;

class FakeUserService extends UserService {
  @override
  Future<bool> hasLoggedInUser() {
    // TODO: implement hasLoggedInUser
    return Future.value(true);
  }

  @override
  Future<String> userId() {
    // TODO: implement userId
    return Future.value("some string");
  }

  @override
  Future<String> userName() {
    // TODO: implement userName
    return Future.value("some user name");
  }

  @override
  Future<void> googleSignIn() {
    // TODO: implement googleSignIn
    return Future.value();
  }
}

class UserService {
  Stream<FirebaseUser> user;

  UserService() {
    user = _auth.onAuthStateChanged;
  }

  Future<bool> hasLoggedInUser() async {
    final user = await _auth.currentUser();
    print('fetched user');
    return (user != null);
  }

  Future<String> userId() async {
    final user = await _auth.currentUser();
    if (user == null) {
      print("user is null");
      return null;
    }
    return user.uid;
  }

  Future<String> userName() async {
    final user = await _auth.currentUser();
    if (user == null) {
      return null;
    }
    return user.displayName;
  }

  Future<void> signOutUser() async {
    return _auth.signOut();
  }

  void loginInAnonymously() async {
    await _auth.signInAnonymously();
  }

  Future<void> googleSignIn() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
    } catch (error) {
      print(error);
    }
  }
}

class UserState {}
