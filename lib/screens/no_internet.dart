import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  static const routeName = '/no_internet';
  const NoInternetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('You are currently offline.'),
    );
  }
}
