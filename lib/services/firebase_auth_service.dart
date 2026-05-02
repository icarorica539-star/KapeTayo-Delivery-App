import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  
  
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  
  Future<void> logout() async {
    await _auth.signOut();
  }

  
  User? get currentUser => _auth.currentUser;

  
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (doc.exists) {
      return doc.data();
    }
    return null;
  }

  // ======================================================
  // ✏️ UPDATE USER PROFILE
  // ======================================================
  Future<void> updateUser({
    required String uid,
    String? name,
    String? email,
  }) async {
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;

    await _firestore.collection('users').doc(uid).update(data);
  }

  
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).delete();
      await user.delete();
    }
  }
}