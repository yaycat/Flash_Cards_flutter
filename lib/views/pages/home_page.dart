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
  String? menuItemCollection;
  List<String> _collections = [];
  String? menuItem = 'hd';
  List<Map<String, dynamic>> _cards = [];
  bool _isLoadingCard = true;
  String? collectionKey;
  bool _isLoadingCollection = true;
  bool? _isCollectionEmpty;

  Future<void> printAllSharedPreferences() async {
    // Получаем экземпляр SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Получаем все ключи, которые хранятся локально
    final Set<String> keys = prefs.getKeys();

    if (keys.isEmpty) {
      print('SharedPreferences is empty.');
      return;
    }

    print('--- Printing all SharedPreferences ---');

    // Перебираем все ключи и печатаем их значения
    for (String key in keys) {
      // Используем prefs.get(), так как не знаем тип данных заранее
      final dynamic value = prefs.get(key);
      print('$key: $value (${value.runtimeType})');
    }

    print('------------------------------------');
  }

  Future<void> deleteThatCollection(String menuItemCollection) async {
    final prefs = await SharedPreferences.getInstance();
    final collectionKey = menuItemCollection;
    if (prefs.containsKey(collectionKey)) {
      await prefs.remove(collectionKey);
      print('Shared Preferences ${collectionKey} deleted');
    } else {
      print('Shared Preferences ${collectionKey} didnt find');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key != 'isDarkKey').toList();
    if (menuItemCollection == null || !keys.contains(menuItemCollection)) {
      menuItemCollection = keys.isNotEmpty ? keys.first : null;
    }

    collectionKey = menuItemCollection;
    _collections = keys;

    if (collectionKey == null) {
      setState(() {
        _cards = [];
        _isCollectionEmpty = true;
        _isLoadingCard = false;
        _isLoadingCollection = false;
      });
      return;
    }

    final List<String> cardStrings = prefs.getStringList(collectionKey!) ?? [];
    final loadedCards = cardStrings.map((cardString) {
      return jsonDecode(cardString) as Map<String, dynamic>;
    }).toList();

    setState(() {
      _cards = loadedCards;
      _isLoadingCard = false;
      _isLoadingCollection = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCollectionEmpty == true
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No collections available. Please create one in settings.',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                IconButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final keys = prefs
                        .getKeys()
                        .where((key) => key != 'isDarkKey')
                        .toList();
                    if (keys.isEmpty) {
                      setState(() {
                        _isCollectionEmpty = true;
                        _loadCards();
                      });
                      print('Collection is empty');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('No collections found.'),
                        ),
                      );
                    } else {
                      setState(() {
                        _isCollectionEmpty = false;
                        _loadCards();
                      });
                      print('Collection is not empty');
                    }
                    _loadCards();
                  },
                  icon: Icon(Icons.refresh),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Column(
                    children: [
                      _isLoadingCollection
                          ? const CircularProgressIndicator()
                          : DropdownButton(
                              value: menuItemCollection,
                              hint: Text('Select Collection'),
                              items: _collections
                                  .map(
                                    (collection) => DropdownMenuItem(
                                      value: collection,
                                      child: Text(collection),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  menuItemCollection = value;
                                  _loadCards();
                                });
                              },
                            ),
                    ],
                  ),
                  SizedBox(height: 10),
                  HeroWidget(collectionKeyfromHome: collectionKey!),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '   Cards:',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
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
                          const DropdownMenuItem(
                            value: 'sh',
                            child: Text('Show'),
                          ),
                          const DropdownMenuItem(
                            value: 'hd',
                            child: Text('Hide'),
                          ),
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
                    child: _isLoadingCard
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
                                collectionName:
                                    cardData['collection'] ?? 'Error',
                              );
                            }).toList(),
                          ),
                  ),

                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Color.fromARGB(222, 108, 3, 14),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Are you sure you want to delete ${menuItemCollection}?',
                            ),
                            content: const Text('This action is irreversible.'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  final collectionToDelete = menuItemCollection;
                                  if (collectionToDelete == null) return;
                                  await deleteThatCollection(
                                    collectionToDelete,
                                  );

                                  Navigator.of(context).pop();

                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final remainingCollections = prefs
                                      .getKeys()
                                      .where((key) => key != 'isDarkKey')
                                      .toList();

                                  setState(() {
                                    _collections = remainingCollections;
                                    menuItemCollection =
                                        remainingCollections.isNotEmpty
                                        ? remainingCollections.first
                                        : null;
                                  });
                                  _loadCards();
                                },

                                child: const Text('Delete'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Delete ${menuItemCollection}'),
                  ),
                ],
              ),
            ),
    );
  }
}
