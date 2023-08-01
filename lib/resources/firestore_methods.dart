import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/comment.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods{

  final FirebaseFirestore  _firebaseFirestore = FirebaseFirestore.instance;

  void addUser(model.User user, UserCredential userCredential) async {
    await _firebaseFirestore.collection('Users').doc(userCredential.user!.uid).set(user.toJson());   // IF YOU WANT TO AUTOGENERATE THE DOC YOU CAN DIRECTLY USE ADD METHOD ON THE FIREBASE FIRESTORE COLLECTION
  }

  Future<String> uploadPost({
    required String description,
    required Uint8List file,
    required String uid,
    required String username,
    required String profileImage,
  }) async {
    String res = "Some error occurred";
    try{
      String photourl = await StorageMethods().uploadImageToStorage(childName: "Posts", file: file, isPost: true);
      String postId = const Uuid().v1();
      Post post = Post(
        likes: [],
        uid: uid,
        username: username,
        datePublished: DateTime.now(),
        description: description,
        postId: postId,
        postUrl: photourl,
        profileImage: profileImage
      );
      _firebaseFirestore.collection('Posts').doc(postId).set(post.toJson());
      res = "success";
    }
    catch(err){
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost({
    required String postId,
    required String uid,
    required List likes
  }) async {

    try{

      // THIS WILL REMOVE UID FROM THE LIST OF LIKES IF IT IS ALREADY IN THERE
      if(likes.contains(uid)){
        await _firebaseFirestore.collection('Posts').doc(postId).update({
          'likes' : FieldValue.arrayRemove([uid]),
        });
      }
      else{
        await _firebaseFirestore.collection('Posts').doc(postId).update({
          'likes' : FieldValue.arrayUnion([uid]),
        });
      }
    }
    catch(e){
      print(e.toString());
    }

  }

  Future<void> postComment({
    required String postId,
    required String comment,
    required String uid,
    required String username,
    required String profilePic
  }) async {

    try{
      if(comment.isNotEmpty){
        String commentId = const Uuid().v1();
        Comment commentobj = Comment(
          uid: uid,
          username: username,
          datePublished: DateTime.now(),
          comment: comment,
          commentId: commentId,
          profilePic: profilePic
        );
        await _firebaseFirestore.collection('Posts').doc(postId).collection('Comments').doc(commentId).set(commentobj.toJson());
      }
      else{
        print('Text is empty');
      }
    }
    catch(e){
      print(e.toString());
    }

  }

  Future<void> deletePost({
    required String postiId
  }) async {

    try{
      await _firebaseFirestore.collection('Posts').doc(postiId).delete();
    }
    catch(e){
      print(e.toString());
    }

  }

  Future<void> followUser({
    required String uid,
    required String followId
  }) async {

    try{
      DocumentSnapshot documentSnapshot = await _firebaseFirestore.collection('Users').doc(uid).get();
      List following = (documentSnapshot.data()! as dynamic)['following'];
      if(following.contains(followId)){
        await _firebaseFirestore.collection('Users').doc(followId).update({
          'followers' : FieldValue.arrayRemove([uid]),
        });
        await _firebaseFirestore.collection('Users').doc(uid).update({
          'following' : FieldValue.arrayRemove([followId]),
        });
      }
      else{
        await _firebaseFirestore.collection('Users').doc(followId).update({
          'followers' : FieldValue.arrayUnion([uid]),
        });
        await _firebaseFirestore.collection('Users').doc(uid).update({
          'following' : FieldValue.arrayUnion([followId]),
        });
      }
    }
    catch(e){
      print(e.toString());
    }

  }

}