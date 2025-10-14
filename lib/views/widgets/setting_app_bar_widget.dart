import 'package:flutter/material.dart';
import 'package:flutter_app/data/constants.dart';
import 'package:flutter_app/data/notifiers/notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SettingsAppBar({super.key, required this.title});

  final String title;

  @override
  State<SettingsAppBar> createState() => _SettingsAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SettingsAppBarState extends State<SettingsAppBar> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, value, child) {
        return AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: Text(widget.title)),
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              onPressed: () async {
                themeNotifier.value = !themeNotifier.value;
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.setBool(KConstant.themeModKey, themeNotifier.value);
              },
              icon: themeNotifier.value
                  ? const Icon(Icons.dark_mode)
                  : const Icon(Icons.light_mode),
            ),
          ],
        );
      },
    );
  }
}
