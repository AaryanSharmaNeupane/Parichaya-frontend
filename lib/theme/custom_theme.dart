import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  // TODO: Customize these theme
  // TODO: add bottomNavigationBarTheme.unselectedItemColor and bottomNavigationBarTheme.selectedItemColor
  // theme: ThemeData(
  //   primarySwatch: Colors.blue,
  //   fontFamily: 'OpenSans',
  //   // brightness: Brightness.dark,
  //   fontFamily: 'QuickSand',
  //   //brightness: Brightness.dark,
  //   textTheme: ThemeData.light().textTheme.copyWith(
  //         bodyText1:
  //             const TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
  //         bodyText2:
  //             const TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
  //         headline1: const TextStyle(
  //             fontSize: 50, fontWeight: FontWeight.bold),
  //         headline2: const TextStyle(fontSize: 45),
  //         headline3: const TextStyle(fontSize: 40),
  //         headline4: const TextStyle(fontSize: 35),
  //         headline5: const TextStyle(fontSize: 30),
  //         headline6: const TextStyle(fontSize: 25),
  //         caption: const TextStyle(fontSize: 20),
  //         overline: const TextStyle(fontSize: 15),
  //         subtitle1: const TextStyle(fontSize: 10),
  //         subtitle2: const TextStyle(fontSize: 10),
  //         button: const TextStyle(fontSize: 10),
  //       ),
  //   // fontFamily: 'Quicksand',
  //   // splashFactory: InkRipple.splashFactory,
  // ),
  static ThemeData lightTheme = ThemeData.light().copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      // colorScheme: const ColorScheme.light(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
      ));

  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.5)),
      // colorScheme: const ColorScheme.dark(),
      // appBarTheme: const AppBarTheme(
      //   backgroundColor: Colors.black,
      // ),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: Colors.white));
}
