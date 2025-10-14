import 'package:flutter/material.dart';
import 'package:flutter_app/data/notifiers/notifier.dart';
import 'package:flutter_app/views/pages/card_creating.dart';

class NavbarWidget extends StatefulWidget {
  const NavbarWidget({super.key});

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      elevation: 2,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          ValueListenableBuilder(
            valueListenable: selectedPageNotifier,
            builder: (context, selectedPage, child) {
              return NavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                  NavigationDestination(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
                onDestinationSelected: (int index) {
                  selectedPageNotifier.value = index;
                },
                selectedIndex: selectedPage,
              );
            },
          ),
          Positioned(
            top: -30,
            child: FloatingActionButton(
              tooltip: 'Add Card',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreatingCard()),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
