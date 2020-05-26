import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:wallp/screens/Explore_Page.dart';
import 'package:wallp/screens/Trending_Page.dart';
import 'package:wallp/screens/Search_Page.dart';
import 'package:wallp/screens/Favourites_Page.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _children = [
    ExplorePage(),
    TrendingPage(),
    SearchPage(),
    FavPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Wall:P',
          style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      resizeToAvoidBottomPadding: false,

      body: _children[_selectedIndex],

      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.white,
          selectedItemBackgroundColor: Color.fromRGBO(108, 99, 255, 1),
          selectedItemIconColor: Colors.white,
          selectedItemLabelColor: Colors.black,
        ),
        selectedIndex: _selectedIndex,
        onSelectTab: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          FFNavigationBarItem(
            iconData: LineAwesomeIcons.rocket,
            label: 'Explore',
          ),
          FFNavigationBarItem(
            iconData: LineAwesomeIcons.fire,
            label: 'Trending',
          ),
          FFNavigationBarItem(
            iconData: LineAwesomeIcons.search,
            label: 'Search',
          ),
          FFNavigationBarItem(
            iconData: Icons.favorite_border,
            label: 'Favourite',
          ),
        ],
      ),
    );
  }
}
