import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<Map<String, dynamic>> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return {'success': 'successfully_logged_in'};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') return {'error': 'account_disabled'};
      if (e.code == 'user-not-found') return {'error': 'email_not_found'};
      if (e.code == 'wrong-password') return {'error': 'password_incorrect'};
      return {'error': 'something_went_wrong'};
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}