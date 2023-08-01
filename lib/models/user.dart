import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String email;
  final String uid;
  final String photourl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  const User({
    required this.email,
    required this.uid,
    required this.photourl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following
  });

  Map<String, dynamic> toJson() => {
    'email' : email,
    'uid' : uid,
    'photourl' : photourl,
    'username' : username,
    'bio' : bio,
    'followers' : followers,
    'following' : following
  };

  static User fromSnap(DocumentSnapshot documentSnapshot){
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return User(
      username: snapshot['username'],
      photourl: snapshot['photourl'],
      following: snapshot['following'],
      followers: snapshot['followers'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      bio: snapshot['bio']
    );
  }

}
