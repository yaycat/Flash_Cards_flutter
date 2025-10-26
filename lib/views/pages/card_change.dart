import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardChange extends StatefulWidget {
  final String frontText;
  final String backText;
  final String collectionKey;

  const CardChange({
    super.key,
    required this.frontText,
    required this.backText,
    required this.collectionKey,
  });

  @override
  State<CardChange> createState() => _CardChangeState();
}

class _CardChangeState extends State<CardChange> {
  final TextEditingController _frontController = TextEditingController();
  final TextEditingController _backController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _frontController.text = widget.frontText;
    _backController.text = widget.backText;
  }

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    super.dispose();
  }

  Future<bool> _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser?.uid;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('User not authenticated. Please log in.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }

    if (_frontController.text.isEmpty || _backController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    final List<String> cards = prefs.getStringList(widget.collectionKey) ?? [];

    final originalData = {'front': widget.frontText, 'back': widget.backText};
    final String originalCardJson = jsonEncode(originalData);
    final int cardIndexToUpdate = cards.indexOf(originalCardJson);

    if (cardIndexToUpdate == -1) {
      debugPrint(widget.collectionKey);
      debugPrint(originalCardJson);
      print(cards);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Original card not found.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    } else if (cardIndexToUpdate != -1) {
      final updatedCardData = {
        'front': _frontController.text,
        'back': _backController.text,
      };

      cards[cardIndexToUpdate] = jsonEncode(updatedCardData);

      await prefs.setStringList(widget.collectionKey, cards);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Card updated successfully.'),
          backgroundColor: Colors.green,
        ),
      );
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Change'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              final bool didSave = await _saveChanges();
              if (didSave) {
                Navigator.pop(context);
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
              controller: _frontController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: widget.frontText,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _backController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: widget.backText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
