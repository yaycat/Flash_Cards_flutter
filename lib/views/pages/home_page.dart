import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/views/pages/card_preview.dart';
import 'package:flutter_app/views/widgets/hero_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? menuItem = 'hd';
  List<Map<String, dynamic>> _cards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    const collectionKey = 'Collection 1';

    final List<String> cardStrings = prefs.getStringList(collectionKey) ?? [];

    final loadedCards = cardStrings.map((cardString) {
      return jsonDecode(cardString) as Map<String, dynamic>;
    }).toList();

    setState(() {
      _cards = loadedCards;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            SizedBox(height: 50),
            HeroWidget(),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '   Cards:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    _loadCards();
                  },
                  icon: Icon(Icons.refresh),
                ),
                DropdownButton(
                  value: menuItem,
                  items: [
                    const DropdownMenuItem(value: 'sh', child: Text('Show')),
                    const DropdownMenuItem(value: 'hd', child: Text('Hide')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      menuItem = value;
                    });
                  },
                ),
              ],
            ),
            Visibility(
              visible: menuItem == 'sh',
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _cards.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('No cards available. Please add some.'),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _cards.map((cardData) {
                        return CardPreview(
                          frontText: cardData['front'] ?? 'Error',
                          backText: cardData['back'] ?? 'Error',
                          collectionName: cardData['collection'] ?? 'Error',
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
