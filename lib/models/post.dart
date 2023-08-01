import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String description;
  final String uid;
  final String postId;
  final String username;
  final datePublished;
  final String postUrl;
  final String profileImage;
  final likes;

  const Post({
    required this.description,
    required this.uid,
    required this.postId,
    required this.username,
    required this.datePublished,
    required this.postUrl,
    required this.profileImage,
    required this.likes
  });

  Map<String, dynamic> toJson() => {
    'description' : description,
    'uid' : uid,
    'postid' : postId,
    'username' : username,
    'datepublished' : datePublished,
    'posturl' : postUrl,
    'profileimage' : profileImage,
    'likes' : likes
  };

  static Post fromSnap(DocumentSnapshot documentSnapshot){
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return Post(
      username: snapshot['username'],
      description: snapshot['description'],
      uid: snapshot['uid'],
      postId: snapshot['postid'],
      datePublished: snapshot['datepublished'],
      postUrl: snapshot['posturl'],
      profileImage: snapshot['profileimage'],
      likes: snapshot['likes']
    );
  }

}
