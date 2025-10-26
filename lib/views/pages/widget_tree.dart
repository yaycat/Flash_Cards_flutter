import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/notifiers/notifier.dart';
import 'package:flutter_app/views/pages/login_page.dart';
import 'package:flutter_app/views/widgets/app_bar_widget.dart';
import 'package:flutter_app/views/pages/home_page.dart';
import 'package:flutter_app/views/widgets/navbar_widget.dart';
import 'package:flutter_app/views/pages/profile_page.dart';

List<Widget> pages = [const HomePage(), const ProfilePage()];

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        debugPrint(
          'StreamBuilder received a snapshot: hasData is ${snapshot.hasData}',
        );
        if (snapshot.hasData) {
          return Scaffold(
            appBar: CustomAppBar(),
            bottomNavigationBar: NavbarWidget(),
            body: ValueListenableBuilder(
              valueListenable: selectedPageNotifier,
              builder: (context, selectedPage, child) {
                return pages[selectedPage];
              },
            ),
          );
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
