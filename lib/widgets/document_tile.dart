import 'dart:io';

import 'package:flutter/material.dart';

import '../utils/string.dart';

class DocumentTile extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback? onTap;
  final Widget? action;

  const DocumentTile({
    required this.title,
    required this.imagePath,
    this.onTap,
    this.action,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.fromLTRB(
            15,
            5,
            5,
            5,
          ),
          leading: Container(
            padding: const EdgeInsets.all(2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(
                  imagePath,
                ),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                semanticLabel: title,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: child,
                  );
                },
              ),
            ),
          ),

          trailing: action,
          title: Text(generateLimitedLengthText(title, 25)),
          // subtitle: Text(document.note.length > 25 ?
          //      note.replaceRange(25, null, '...')
          //     : document.note),
        ),
        const Divider(
          indent: 10,
          endIndent: 10,
          height: 1,
        )
      ],
    );
  }
}
