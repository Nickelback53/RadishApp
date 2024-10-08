import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radish_app/screen/home/items_page.dart';
import 'package:radish_app/screen/home/map_page.dart';
import 'package:radish_app/states/user_provider.dart';
import 'package:radish_app/widget/expandablefab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _bottomSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('후암동', style: Theme.of(context).appBarTheme.titleTextStyle,),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.search)
          ),
          IconButton(
              onPressed: () {
                
              },
              icon: Icon(Icons.list)
          ),
          IconButton(
              onPressed: () {

              },
              icon: Icon(Icons.notifications)
          ),
        ],
      ),
      body: IndexedStack(
        index: _bottomSelectedIndex,
        children: [
          ItemPage(),
          (context.read<UserProvider>().userModel == null)
            ? Container()
            : MapPage(context.read<UserProvider>().userModel!),
          Container(
            color: Colors.accents[10],
          ),
          Container(
            color: Colors.accents[15],
          ),
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 90, 
        children: [
          MaterialButton(
            onPressed: (){
              context.beamToNamed('input');
            },
            shape: CircleBorder(),
            height: 40,
            color: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.add),  
          ),
           MaterialButton(
            onPressed: (){

            },
            shape: CircleBorder(),
            height: 40,
            color: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.add),  
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomSelectedIndex,
        onTap: (index) {
          setState(() {
            _bottomSelectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(
              _bottomSelectedIndex == 0
                ? 'assets/icons/icon_home_select.png'
                : 'assets/icons/icon_home_normal.png'
            )), 
            label: '홈'
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(
              _bottomSelectedIndex == 1
                ? 'assets/icons/icon_location_select.png'
                : 'assets/icons/icon_location_normal.png'
            )), 
            label: '내근처'
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(
              _bottomSelectedIndex == 2
                ? 'assets/icons/icon_chat_select.png'
                : 'assets/icons/icon_chat_normal.png'
            )), 
            label: '채팅'
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(
              _bottomSelectedIndex == 3
                ? 'assets/icons/icon_info_select.png'
                : 'assets/icons/icon_info_normal.png'
            )), 
            label: '내정보'
          ),
        ]
      ),
    );
  }
}
