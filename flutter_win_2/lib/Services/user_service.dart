import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_win_2/Model/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

final usersRef = Firestore.instance.collection('users');

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

final _auth = FirebaseAuth.instance;

class UserService {
  Stream<FirebaseUser> user;
  final _userStream = BehaviorSubject<User>();
  Stream<User> get loggedInUser => _userStream.stream;

  UserService() {
    user = _auth.onAuthStateChanged;
    user.distinctUnique().flatMap(getUserStream).pipe(_userStream);
  }

  Stream<User> getUserStream(FirebaseUser firebaseUser) {
    print("get user stream called");
    if (firebaseUser == null) {
      return null;
    }
    return usersRef
        .limit(1)
        .where("userId", isEqualTo: firebaseUser.uid)
        .snapshots()
        .map((snapshot) {
      List<DocumentSnapshot> documents = snapshot.documents;
      return documents.map((e) => User.fromDocument(e)).toList().first;
    });
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

  Future<void> loginInAnonymously() async {
    return _auth.signInAnonymously();
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
      createUserInFirestoreIfNeeded();
    } catch (error) {
      print(error);
    }
  }

  dispose() {
    _userStream.close();
  }

  createUserInFirestoreIfNeeded() async {
    print("creating users");
    final FirebaseUser firebaseUser = await _auth.currentUser();
    final firebaseUserId = firebaseUser.uid;
    DocumentSnapshot doc = await usersRef.document(firebaseUserId).get();

    if (!doc.exists) {
      final newUser = User(
        userId: firebaseUserId,
        username: "",
        email: firebaseUser.email,
        photoUrl: firebaseUser.photoUrl,
        displayName: firebaseUser.displayName,
        memberSince: DateTime.now(),
      );

      //3) get username from create account, use it to make new user document in users collection
      usersRef.document(firebaseUserId).setData(newUser.data());

      doc = await usersRef.document(firebaseUserId).get();
    } else {
      var map = doc.data;
      map['lastSeen'] = DateTime.now();
      usersRef.document(firebaseUserId).updateData(map);
      print('updatedLastSeen');
    }
  }
}

class FakeUserService extends UserService {
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
