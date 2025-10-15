import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatingCard extends StatefulWidget {
  const CreatingCard({super.key});

  @override
  State<CreatingCard> createState() => _CreatingCardState();
}

Future<void> printAllSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final Set<String> keys = prefs.getKeys();

  if (keys.isEmpty) {
    print('SharedPreferences is empty.');
    return;
  }
  print('--- Printing all SharedPreferences ---');
  for (String key in keys) {
    final dynamic value = prefs.get(key);
    print('$key: $value (${value.runtimeType})');
  }
  print('------------------------------------');
}

class _CreatingCardState extends State<CreatingCard> {
  final TextEditingController _frontController = TextEditingController();
  final TextEditingController _backController = TextEditingController();
  List<String> _collections = [];
  String? _selectedCollection;
  int? countcards;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCollections();
  }

  Future<void> _loadCollections() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key != 'isDarkKey').toList();

    setState(() {
      _collections = keys;
      _isLoading = false;
    });
  }

  Future<bool> _saveCard() async {
    if (_frontController.text.isEmpty ||
        _backController.text.isEmpty ||
        _selectedCollection == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Please fill all fields and select a collection.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }

    final prefs = await SharedPreferences.getInstance();

    final String _selectedCollectionKey = _selectedCollection!;
    final List<String> cards =
        prefs.getStringList(_selectedCollectionKey) ?? [];

    final cardData = {
      'front': _frontController.text,
      'back': _backController.text,
      'collection': _selectedCollection,
    };
    cards.add(jsonEncode(cardData));

    await prefs.setStringList(_selectedCollectionKey, cards);
    countcards = cards.length;
    return true;
  }

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Card'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              final bool didSave = await _saveCard();
              if (didSave && mounted) {
                print('Card Saved in Collection "$_selectedCollection"!');
                print(
                  'Front: ${_frontController.text}, Back: ${_backController.text}, Collection:$_selectedCollection',
                );
                print(countcards);
                printAllSharedPreferences();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Collection',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedCollection,
                    hint: const Text('Collection'),
                    items: _collections.map((String collection) {
                      return DropdownMenuItem<String>(
                        value: collection,
                        child: Text(collection),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCollection = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 14),
                  TextField(
                    controller: _frontController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Front Text',
                    ),
                  ),
                  SizedBox(height: 14),
                  TextField(
                    controller: _backController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Back Text',
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
