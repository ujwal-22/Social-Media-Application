import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/storage_methods.dart';

import 'firestore_methods.dart';

class AuthMethods{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async{
    User currentUser = _firebaseAuth.currentUser!;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('Users').doc(currentUser.uid).get();
    return model.User.fromSnap(documentSnapshot);
  }

  // SIGN UP USER
  Future<String> signupUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file
  }) async {

    String res = "Some error occurred";
    try{
      if(email.isNotEmpty && password.isNotEmpty && username.isNotEmpty && bio.isNotEmpty && file != null){

        // REGISTER USER
        UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

        // ADD A USER PROFILE PHOTO IN THE FIREBASE STORAGE
        String profilephotourl = await StorageMethods().uploadImageToStorage(
          childName: 'profilePics',
          file: file,
          isPost : false
        );

        model.User user  = model.User(
          username: username,
          email: email,
          bio: bio,
          uid: userCredential.user!.uid,
          followers: [],
          following: [],
          photourl: profilephotourl
        );

        // ADD A USER TO THE FIRESTORE
        FirestoreMethods().addUser(user, userCredential);
        // await _firebaseFirestore.collection('Users').doc(userCredential.user!.uid).set(user.toJson());   // IF YOU WANT TO AUTOGENERATE THE DOC YOU CAN DIRECTLY USE ADD METHOD ON THE FIREBASE FIRESTORE COLLECTION
        res = 'success';
      }
      else{
        res = 'Please enter all the required details';
      }
    }

    // THIS IS USED TO HANDLE THE FIREBASE EXCEPTION
    // on FirebaseAuthException catch(err){
    //   if(err.code == 'invalid-email') res = 'The email address is badly formatted';
    //   else if(err.code == 'weak-password') res = 'Your password should be at least 6  characters';
    // }
    catch(e){
      res = e.toString();
    }

    return res;

  }

  // LOG IN USER
  Future<String> logInUser({
    required String email,
    required String password
  }) async {

    String res = "Some error occurred";
    try{
      if(email.isNotEmpty && password.isNotEmpty){
        await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
        res =  "success";
      }
      else{
        res = "Please enter correct email and password";
      }
    }
    catch(err){
      res = err.toString();
    }
    return res;
  }

  // SIGN OUT USE
  Future<void> signOutUser() async {
    await _firebaseAuth.signOut();
  }

}