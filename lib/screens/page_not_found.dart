import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text("Page not found."),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/');
                },
                child: const Text("Go back to homescreen."))
          ],
        ),
      ),
    );
  }
}
