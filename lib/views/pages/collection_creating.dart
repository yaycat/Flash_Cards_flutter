import 'dart:math' as developer;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectionCreating extends StatefulWidget {
  const CollectionCreating({super.key});

  @override
  State<CollectionCreating> createState() => _CollectionCreatingState();
}

class _CollectionCreatingState extends State<CollectionCreating> {
  final TextEditingController _collectionNameController =
      TextEditingController();

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

  Future<bool> _saveCollection() async {
    if (_collectionNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Please enter a collection name.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    final String collectionName = _collectionNameController.text;

    if (prefs.containsKey(collectionName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Collection already exists. Please choose another name.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }

    await prefs.setStringList(collectionName, []);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Collection'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              if (await _saveCollection()) {
                if (mounted) {
                  printAllSharedPreferences();
                  print(
                    'Collection "${_collectionNameController.text}" created!',
                  );
                  Navigator.pop(context);
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            TextField(
              controller: _collectionNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Collection Name',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
