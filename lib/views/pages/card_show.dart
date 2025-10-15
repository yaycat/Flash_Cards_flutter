import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardShow extends StatefulWidget {
  final String collectionKeyfromHero;
  const CardShow({super.key, required this.collectionKeyfromHero});

  @override
  State<CardShow> createState() => _CardShowState();
}

class _CardShowState extends State<CardShow> {
  List<Map<String, dynamic>> _allCards = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _isShowingAnswer = false;
  bool _isFinished = false;
  String? showButton;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final collectionKey = widget.collectionKeyfromHero;

    final List<String> cardStrings = prefs.getStringList(collectionKey) ?? [];

    if (cardStrings.isEmpty) {
      setState(() {
        _isFinished = true;
        _isLoading = false;
      });
      return;
    }

    final loadedCards = cardStrings.asMap().entries.map((entry) {
      int idx = entry.key;
      String cardString = entry.value;
      Map<String, dynamic> cardData = jsonDecode(cardString);
      return {
        'id': idx,
        'front': cardData['front'] ?? 'No Front Text',
        'back': cardData['back'] ?? 'No Back Text',
      };
    }).toList();

    setState(() {
      _allCards = loadedCards;
      _isLoading = false;
    });
  }

  void _goToNextCard() {
    setState(() {
      if (_currentIndex < _allCards.length - 1) {
        _currentIndex++;
        _isShowingAnswer = false;
      } else {
        _isFinished = true;
      }
    });
  }

  String _getCurrentText() {
    if (_isShowingAnswer) {
      return _allCards[_currentIndex]['back'];
    } else {
      return _allCards[_currentIndex]['front'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: 'hero-image',
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                'assets/images/de ya nahu.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.6)),
          Positioned(
            top: 40.0,
            left: 10.0,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            top: 40.0,
            right: 10.0,
            child: Visibility(
              visible: showButton == 'shown',
              child: IconButton(
                icon: Icon(
                  _isFinished ? Icons.check : Icons.navigate_next,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: _isFinished
                    ? () => Navigator.of(context).pop()
                    : _goToNextCard,
              ),
            ),
          ),
          Center(
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : _isFinished
                ? const Text(
                    'Congratulations!\nYou finished this collection',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Card №${_allCards[_currentIndex]['id'] + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 500,
                        padding: const EdgeInsets.symmetric(
                          vertical: 25.0,
                          horizontal: 20.0,
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 20.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            _getCurrentText(), // Показываем нужный текст
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isShowingAnswer = true;
                            showButton = 'shown';
                          });
                        },
                        child: const Text('Show Answer'),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
