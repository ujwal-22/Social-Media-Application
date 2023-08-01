import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  var userdata = {};
  int totalposts = 0, totalfollowers = 0, totalfollowing = 0;
  bool isFollowing = false, isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ?
    const Center(
      child: CircularProgressIndicator(),
    ) :
    Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          userdata['username'],
        ),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [

                    // PROFILE IMAGE SECTION
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        userdata['photourl'],
                      ),
                      radius: 40,
                    ),

                    // PROFILE INFORMATION SECTION
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [

                          // FOLLOWERS, FOLLOWING, POSTS
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              buildStatColumn(totalposts, 'Posts'),
                              buildStatColumn(totalfollowers, 'Followers'),
                              buildStatColumn(totalfollowing, 'Following'),
                            ],
                          ),

                          // BUTTON
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid == widget.uid ?

                              // EDIT PROFILE BUTTON
                              FollowButton(
                                text: 'Sign out',
                                backgroundColor: mobileBackgroundColor,
                                textColor: primaryColor,
                                borderColor: Colors.grey,
                                function: () async {
                                  await AuthMethods().signOutUser();
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ));
                                },
                              ) :

                              isFollowing ?

                              // UNFOLLOW BUTTON
                              FollowButton(
                                text: 'Unfollow',
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                borderColor: Colors.grey,
                                function: () async {
                                  await FirestoreMethods().followUser(uid: FirebaseAuth.instance.currentUser!.uid, followId: userdata['uid']);
                                  setState(() {
                                    isFollowing = false;
                                    totalfollowers--;
                                  });
                                },
                              ) :

                              // FOLLOW BUTTON
                              FollowButton(
                                text: 'Follow',
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                borderColor: Colors.blue,
                                function: () async {
                                  await FirestoreMethods().followUser(uid: FirebaseAuth.instance.currentUser!.uid, followId: userdata['uid']);
                                  setState(() {
                                    isFollowing = true;
                                    totalfollowers++;
                                  });
                                },
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // USERNAME AND BIO SECTION
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    userdata['username'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    userdata['bio'],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          // POSTS SECTION
          FutureBuilder(
            future: FirebaseFirestore.instance.collection('Posts').where('uid', isEqualTo: widget.uid).get(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return GridView.builder(
                shrinkWrap: true,
                itemCount: (snapshot.data! as dynamic).docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 1.5,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index){
                  DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];
                  return Container(
                    child: Image(
                      image: NetworkImage(
                        snap['posturl']
                      ),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            },
          )

        ],
      ),
    );
  }

  Column buildStatColumn(int num, String label){

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.grey
            ),
          ),
        )
      ],
    );

  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    try{
      var usersnap = await FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(widget.uid)
                                            .get();
      var postsnap = await FirebaseFirestore.instance
                                            .collection('Posts')
                                            .where('uid', isEqualTo: FirebaseAuth.instance
                                            .currentUser!
                                            .uid)
                                            .get();
      userdata = usersnap.data()!;
      totalposts = postsnap.docs.length;
      totalfollowers = usersnap.data()!['followers'].length;
      totalfollowing = usersnap.data()!['following'].length;
      isFollowing = usersnap.data()!['following'].contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    }
    catch(e){
      showSnackBar(content: e.toString(), context: context);
    }
    setState(() {
      isLoading = true;
    });
  }

}
