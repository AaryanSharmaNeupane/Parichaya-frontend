import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parichaya_frontend/providers/preferences.dart';
import 'package:provider/provider.dart';
import 'package:parichaya_frontend/screens/onboarding_screen.dart';

import './providers/documents.dart';
import 'providers/share_links.dart';

import './screens/document_detail_full_screen_gallery.dart';
import './screens/buttom_navigation_base.dart';
import './screens/add_document.dart';
import './screens/document_details.dart';
import './screens/edit_document.dart';
import './screens/select_document.dart';
import './screens/set_expiry.dart';
import './screens/share_details.dart';
import './screens/onboarding_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import './theme/custom_theme.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final prefs = Preferences.noSync();
  await prefs.syncToSharedPreferences();
  FlutterNativeSplash.remove();

  runApp(ChangeNotifierProvider<Preferences>(
    create: (_) => prefs,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Documents()),
        ChangeNotifierProvider(create: (_) => ShareLinks()),
      ],
      child: Consumer<Preferences>(
        builder: (context, prefs, child) {
          return MaterialApp(
            title: 'Parichaya',
            theme: CustomTheme.lightTheme,
            darkTheme: CustomTheme.darkTheme,
            themeMode: prefs.themeMode,
            debugShowCheckedModeBanner: false,
            initialRoute:
                prefs.isOnboardingComplete ? '/' : OnboardingScreen.routeName,
            routes: {
              '/': (ctx) => const ButtomNavigationBase(),
              ButtomNavigationBase.routeName: (ctx) =>
                  const ButtomNavigationBase(),
              OnboardingScreen.routeName: (ctx) => const OnboardingScreen(),
              AddDocuments.routeName: (ctx) => const AddDocuments(),
              DocumentDetails.routeName: (ctx) => const DocumentDetails(),
              EditDocument.routeName: (ctx) => const EditDocument(),
              DocumentDetailFullScreenGallery.routeName: (ctx) =>
                  const DocumentDetailFullScreenGallery(),
              SelectDocument.routeName: (ctx) => const SelectDocument(),
              SetExpiry.routeName: (ctx) => const SetExpiry(),
              ShareDetails.routeName: (ctx) => const ShareDetails(),
            },
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (ctx) => const ButtomNavigationBase(),
              );
            },
          );
        },
      ),
    );
  }
}
