import 'package:flutter/material.dart';
import 'package:flutter_app/data/constants.dart';
import 'package:flutter_app/views/pages/card_change.dart';

class CardPreview extends StatefulWidget {
  final String frontText;
  final String backText;
  final String collectionName;

  const CardPreview({
    super.key,
    required this.frontText,
    required this.backText,
    required this.collectionName,
  });

  @override
  State<CardPreview> createState() => _CardPreviewState();
}

class _CardPreviewState extends State<CardPreview> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CardChange(
              frontText: widget.frontText,
              backText: widget.backText,
              collectionKey: widget.collectionName,
            ),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Card', style: KTextStyle.cardtitleText),
              Text(widget.frontText, style: KTextStyle.descriptionTextQuestion),
              Text(widget.backText, style: KTextStyle.descriptionTextAnswer),
            ],
          ),
        ),
      ),
    );
  }
}
