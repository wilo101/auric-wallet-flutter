import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

/// UI depends on this interface only, so the app runs with or without Firebase.
abstract class AuthService {
  Stream<String?> get userId;
  Future<void> signIn(String email, String password);
  Future<void> signOut();
}

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<String?> get userId => _auth.authStateChanges().map((u) => u?.uid);

  @override
  Future<void> signIn(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  @override
  Future<void> signOut() => _auth.signOut();
}

/// Demo mode: any credentials work. Lets reviewers run the UI instantly.
class MockAuthService implements AuthService {
  String? _uid;
  final _controller = StreamController<String?>.broadcast();

  @override
  Stream<String?> get userId async* {
    yield _uid; // current value first, then every change
    yield* _controller.stream;
  }

  @override
  Future<void> signIn(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _uid = 'demo-user';
    _controller.add(_uid);
  }

  @override
  Future<void> signOut() async {
    _uid = null;
    _controller.add(null);
  }
}
