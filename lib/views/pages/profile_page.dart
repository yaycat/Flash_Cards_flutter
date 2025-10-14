import 'package:flutter/material.dart';
import 'package:flutter_app/data/constants.dart';
import 'package:flutter_app/data/notifiers/notifier.dart';
import 'package:flutter_app/views/pages/welcome_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/chinese_house.jpeg'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Profile Name:', style: KTextStyle.descriptionText),
              Text('yaycat', style: KTextStyle.normalText),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Email:', style: KTextStyle.descriptionText),
              Text('yaycat@example.com', style: KTextStyle.normalText),
            ],
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: (Text('Logout', style: KTextStyle.buttonText)),
            onTap: () {
              selectedPageNotifier.value = 0;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
