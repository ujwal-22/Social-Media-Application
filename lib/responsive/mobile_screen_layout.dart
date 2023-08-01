import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {

  // THIS IS ONE WAY TO ACCESS DATA FROM THE FIREBASE
  // String username = '';
  //
  // @override
  // void initState() {
  //   super.initState();
  //   getUsername();
  // }
  // void getUsername() async {
  //
  //   DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).get();
  //
  //   setState(() {
  //     username = (documentSnapshot.data() as Map<String, dynamic>)['username'];
  //   });
  //
  // }

  late PageController pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {

    // model.User user = Provider.of<UserProvider>(context).getUser!;

    return Scaffold(

      body: PageView(
        children: homeScreenItems,
        physics: const NeverScrollableScrollPhysics(),    // THIS WILL RESTRICT THE USER FROM CHANGING THE USER BY SWIPING THE SCREEN
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        onTap: navigationTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _page==0 ? primaryColor : secondaryColor,),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: _page==1 ? primaryColor : secondaryColor,),
            label: '',
            backgroundColor: primaryColor,
          ),BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, color: _page==2 ? primaryColor : secondaryColor,),
            label: '',
            backgroundColor: primaryColor,
          ),BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: _page==3 ? primaryColor : secondaryColor,),
            label: '',
            backgroundColor: primaryColor,
          ),BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _page==4 ? primaryColor : secondaryColor,),
            label: '',
            backgroundColor: primaryColor,
          ),
        ],
      ),

    );
  }


  void navigationTapped(int value) {
    pageController.jumpToPage(value);
  }

  void onPageChanged(int value) {
    setState(() {
      _page = value;
    });
  }
}
