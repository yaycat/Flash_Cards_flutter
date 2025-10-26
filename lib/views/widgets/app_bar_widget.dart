import 'package:flutter/material.dart';
import 'package:flutter_app/data/notifiers/notifier.dart';
import 'package:flutter_app/views/pages/collection_creating.dart';
import 'package:flutter_app/views/pages/settings_page.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, value, child) {
        return AppBar(
          title: Text('Flash Cards'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CollectionCreating()),
              );
            },
            icon: const Icon(Icons.add),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SettingsPage(title: 'Settings Page');
                    },
                  ),
                );
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        );
      },
    );
  }
}
