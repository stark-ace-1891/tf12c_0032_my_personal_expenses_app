import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tf12c_0032_my_personal_expenses_app/core/exceptions/exceptions.dart';
import 'package:tf12c_0032_my_personal_expenses_app/models/local_user.dart';

class AthenticationService {
  final googleSignIn = GoogleSignIn();
  final firebaseAuth = FirebaseAuth.instance;
  final cloudFirestore = FirebaseFirestore.instance;

  Future<LocalUser> signInWithGoogle() async {
    final googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      final credentials = GoogleAuthProvider.credential(
          idToken: idToken, accessToken: accessToken);

      final firebaseSignIn =
          await firebaseAuth.signInWithCredential(credentials);

      final firebaseUser = firebaseSignIn.user;

      if (firebaseUser != null) {
        try {
          final localUser = LocalUser(
            id: firebaseUser.uid,
            name: firebaseUser.displayName,
            photoUrl: firebaseUser.photoURL,
          );

          final result = await cloudFirestore
              .collection('users')
              .where(
                'id',
                isEqualTo: firebaseUser.uid,
              )
              .get();

          final documents = result.docs;

          if (documents.isEmpty) {
            await cloudFirestore
                .collection('users')
                .doc(firebaseUser.uid)
                .set(localUser.toJson());
          }

          return localUser;
        } catch (e) {
          throw LoginException();
        }
      } else {
        throw LoginException();
      }
    } else {
      throw LoginInWithGoogleException();
    }
  }

  Future<bool> isLoggedIn() async {
    final isGoogleSignIn = await googleSignIn.isSignedIn();
    return firebaseAuth.currentUser != null && isGoogleSignIn ? true : false;
  }

  Future<void> googleLogOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }
}
