import 'package:cloud_firestore/cloud_firestore.dart';

class Comment{
  final String profilePic;
  final String username;
  final String uid;
  final String comment;
  final String commentId;
  final datePublished;

  const Comment({
    required this.commentId,
    required this.comment,
    required this.profilePic,
    required this.uid,
    required this.username,
    required this.datePublished,
  });

  Map<String, dynamic> toJson() => {
    'comment' : comment,
    'uid' : uid,
    'commentid' : commentId,
    'username' : username,
    'datepublished' : datePublished,
    'profilepic' : profilePic,
  };

  static Comment fromSnap(DocumentSnapshot documentSnapshot){
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return Comment(
        username: snapshot['username'],
        comment: snapshot['comment'],
        uid: snapshot['uid'],
        commentId: snapshot['commentid'],
        datePublished: snapshot['datepublished'],
        profilePic: snapshot['profilepic'],
    );
  }

}
