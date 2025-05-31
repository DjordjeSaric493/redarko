import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:redarko/screens/home_scr.dart';
import 'package:redarko/screens/map_scr.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: const HomeScreen(),
          item: ItemConfig(icon: Icon(Icons.home), title: "Home"),
        ),
        PersistentTabConfig(
          screen: const MapScreen(),
          item: ItemConfig(icon: Icon(Icons.map), title: "Map"),
        ),
      ],
      navBarBuilder:
          (navBarConfig) => Style1BottomNavBar(navBarConfig: navBarConfig),
    );
  }
}
