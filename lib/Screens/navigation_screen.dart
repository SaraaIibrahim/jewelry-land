import 'package:flutter/material.dart';
import 'package:jewelry_land/Screens/NavigationScreensUsers/home_screen.dart';
import 'package:jewelry_land/Screens/NavigationScreens/my_designs_screen.dart';
import 'package:jewelry_land/Screens/NavigationScreens/orders_screen.dart';
import 'package:jewelry_land/Screens/NavigationScreens/profile_screen.dart';
import 'package:jewelry_land/Screens/NavigationScreensUsers/cart_screen.dart';
import 'package:jewelry_land/Widgets/Drawer/drawer_list.dart';
import 'package:jewelry_land/Widgets/Drawer/header_drawer.dart';

class NavigationScreen extends StatefulWidget {
  static const routeName = "NAVIGATION_SCREEN";
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  PageController pageController = PageController(initialPage: 0);
  int index = 0;
  final screensDesigners = [
    MyDesignsScreen(),
    ProfileScreen(),
  ];
  final screensUsers = [
    HomeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final userModel = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
      return Scaffold(
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  HeaderDrawer(userModel: userModel['userModel']),
                  DrawerList(userModel: userModel['userModel'] ),
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          surfaceTintColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: const Text("Jewelry Land", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),),
          centerTitle: true,
          toolbarHeight: 70,
          elevation: 0.5,
          actions: [
            userModel['userModel']?.typeUser == 'user'?IconButton(onPressed: (){
              Navigator.of(context).pushNamed(CartScreen.routeName);

            }, icon: Icon(Icons.shopping_cart)):IconButton(onPressed: (){
              Navigator.of(context).pushNamed(OrdersScreen.routeName);
            }, icon: Icon(Icons.featured_play_list_rounded)),
          ],
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (page){
            setState(() {
              index = page;
            });
          },
          children: userModel['userModel']?.typeUser == 'user'?screensUsers:screensDesigners,
        ),
        bottomNavigationBar: NavigationBarTheme(
          data: const NavigationBarThemeData(
            indicatorColor:  Colors.transparent,
            labelTextStyle: MaterialStatePropertyAll(TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black)),
            
          ),
          child: NavigationBar(
            elevation: 5,
            surfaceTintColor: Colors.black,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            animationDuration: Duration(seconds: 1),
            selectedIndex: index,
            onDestinationSelected: (index) {
              setState(() {
                this.index = index;
                pageController.animateToPage(index,duration: Duration(milliseconds: 300),curve: Curves.easeInOut);
              });
            },
            height: 70,
            backgroundColor: Colors.white,

            destinations: [
              userModel['userModel']?.typeUser == 'user'?const NavigationDestination(
                  icon: Icon(Icons.home_outlined,size: 30,color: Colors.black,),
                  selectedIcon: Icon(Icons.home,size: 30,color: Colors.black,),
                  label: "Home"
              ):const NavigationDestination(
                  icon: Icon(Icons.diamond_outlined,size: 30,color: Colors.black,),
                  selectedIcon: Icon(Icons.diamond,size: 30,color: Colors.black,),
                  label: "My Designs"
              ), const NavigationDestination(
                  icon: Icon(Icons.person_outlined,size: 30,color: Colors.black,),
                  selectedIcon: Icon(Icons.person,size: 30,color: Colors.black,),
                  label: "Profile",
              ),
            ],
          ),
        ),
      );

  }
}
