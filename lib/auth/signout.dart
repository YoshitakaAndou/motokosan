import 'package:firebase_auth/firebase_auth.dart';

class SignOut {
  static final SignOut instance = SignOut();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signOut() async {
    await _auth.signOut();
    print("サインアウトしました");
    // final _google = await _googleSignIn.isSignedIn();
  }
}
