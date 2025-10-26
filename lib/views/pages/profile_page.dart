import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/constants.dart';
import 'package:flutter_app/data/notifiers/notifier.dart';
import 'package:flutter_app/views/pages/login_page.dart';
import 'package:flutter_app/views/pages/welcome_page.dart';
import 'package:flutter_app/views/pages/widget_tree.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/chinese_house.jpeg'),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Email:', style: KTextStyle.descriptionText),
              Text(
                user?.email ?? 'Email not found',
                style: KTextStyle.normalText,
              ),
            ],
          ),
          const Divider(),
          SizedBox(height: 10),

          ListTile(
            leading: Icon(Icons.logout),
            title: (Text('Logout', style: KTextStyle.buttonText)),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WidgetTree()),
              );
            },
          ),
        ],
      ),
    );
  }
}
