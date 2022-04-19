import 'package:flutter/material.dart';

class DoneButton extends StatelessWidget {
  final String text;
  final Icon icon;
  final VoidCallback onPressed;

  const DoneButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ElevatedButton(
        // label: Text(text),
        child: Text(text),
        // icon: icon,
        onPressed: onPressed,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(0),

          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              // side: BorderSide(color: Colors.red),
            ),
          ),
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).primaryColorDark),
          foregroundColor: MaterialStateProperty.all(
            Colors.white,
            // overlayColor: MaterialStateProperty.all(
            //     Theme.of(context).primaryColor.withOpacity(0.1)),
          ),
          // label: Text(text),
          // child: Text(text),
        ),
      ),
    );
  }
}
