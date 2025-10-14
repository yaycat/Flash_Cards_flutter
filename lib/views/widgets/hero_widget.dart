import 'package:flutter/material.dart';
import 'package:flutter_app/views/pages/card_show.dart';

class HeroWidget extends StatefulWidget {
  const HeroWidget({super.key});

  @override
  State<HeroWidget> createState() => _HeroWidgetState();
}

class _HeroWidgetState extends State<HeroWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CardShow()),
        );
      },
      splashColor: const Color.fromARGB(255, 0, 121, 109),
      borderRadius: BorderRadius.circular(28.0),
      child: Hero(
        tag: 'hero-image',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Image.asset(
            width: 380,
            height: 235,
            'assets/images/de ya nahu.jpg',
            color: const Color.fromARGB(255, 212, 210, 254),
            colorBlendMode: BlendMode.darken,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
