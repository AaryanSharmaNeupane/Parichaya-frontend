// import 'package:flutter/material.dart';
// import 'package:parichaya_frontend/utils/is_first_run.dart';

// import 'onboarding_screen.dart';
// import 'package:provider/provider.dart';
// import '../providers/theme_provider.dart';
// import 'buttom_navigation_base.dart';

// class Splash extends StatefulWidget {
//   const Splash({Key? key}) : super(key: key);

//   @override
//   State<Splash> createState() => _SplashState();
// }

// class _SplashState extends State<Splash> {
//   bool isDarkModeOn = false;
//   bool isFirstRun = false;

//   checkFirstRun() async {
//     IsFirstRun.instance
//         .getBooleanValue("isfirstRun")
//         .then((value) => setState(() {
//               isFirstRun = value;
//             }));
//   }

//   @override
//   void initState() {
//     super.initState();
//     _navigatetohome();
//     checkFirstRun();
//   }

//   _navigatetohome() async {
//     await Future.delayed(const Duration(milliseconds: 1200), () {});

//     !isFirstRun
//         ? Navigator.of(context).pushNamed(OnboardingScreen.routeName)
//         : Navigator.of(context).pushNamed(ButtomNavigationBase.routeName);
//   }

//   Widget build(BuildContext context) {
//     isDarkModeOn =
//         Provider.of<ThemeProvider>(context, listen: false).isDarkModeOn;
//     return Scaffold(
//         body: Center(
//       child: Container(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.fingerprint_rounded,
//                   color: isDarkModeOn
//                       ? Colors.blue
//                       : Theme.of(context).primaryColor,
//                   size: 40,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   'PARICHAYA',
//                   style: TextStyle(
//                     fontSize: 30,
//                     // fontWeight: FontWeight.bold,
//                     color: isDarkModeOn ? Colors.white : Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Text(
//               'AN IDENTITY STORAGE AND SHARING APP',
//               style: Theme.of(context).textTheme.bodySmall,
//               // style: TextStyle(
//               //   fontSize: 14,
//               //   fontWeight: FontWeight.w400,
//               // ),
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
// }
