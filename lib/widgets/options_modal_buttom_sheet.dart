import 'package:flutter/material.dart';

void showOptionsModalButtomSheet(BuildContext context,
    {List<Widget> children = const []}) {
  showModalBottomSheet<void>(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            children: children,
          ),
        ),
      );
    },
  );
}
