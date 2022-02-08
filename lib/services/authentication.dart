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
      if (e.code == 'user-disabled') return {'error': 'This account has been disabled'};
      if (e.code == 'user-not-found') return {'error': 'Email not found'};
      if (e.code == 'wrong-password') return {'error': 'Incorrect password'};
      return {'error': 'Something went wrong'};
    }
  }

  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return {'success': 'Password reset mail has been send'};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') return {'error': 'Email not found'};
      return {'error': 'Something went wrong'};
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}