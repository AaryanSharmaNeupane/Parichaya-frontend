import 'package:flutter/material.dart';
import 'package:parichaya_frontend/providers/preferences.dart';
import 'package:provider/provider.dart';

import '../screens/about_us.dart';
import '../screens/update_name.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<Preferences>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 130,
            child: DrawerHeader(
              decoration: BoxDecoration(
                // TODO: Make this work without condition checking.
                color: Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade500,
              ),
              child: Row(
                children: [
                  // if (prefs.username.isNotEmpty)
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    // radius: 50,
                    child: Text(
                      prefs.username.isEmpty
                          ? 'P'
                          : prefs.username[0].toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  //   ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        prefs.username.isEmpty
                            ? 'Parichaya User'
                            : prefs.username,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
//Switch for dark mode
          Consumer<Preferences>(
            builder: (context, pref, child) {
              return ListTile(
                title: Row(
                  children: [
                    Icon(prefs.themeMode == ThemeMode.dark
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        prefs.themeMode == ThemeMode.dark
                            ? 'Dark Mode'
                            : 'Light Mode',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: Switch(
                  value: prefs.themeMode == ThemeMode.dark,
                  onChanged: (isDarkModeOn) {
                    if (isDarkModeOn) {
                      prefs.setThemeMode(ThemeMode.dark);
                    } else {
                      prefs.setThemeMode(ThemeMode.light);
                    }
                  },
                  activeTrackColor: Theme.of(context).primaryColorLight,
                  activeColor: Theme.of(context).primaryColor,
                ),
                //onTap: () {},
              );
            },
          ),
          const Divider(),

          ListTile(
            title: Row(
              children: const [
                Icon(Icons.edit),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Change Profile Name',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UpdateName(),
                ),
              );
            },
            // trailing: const Icon(Icons.arrow_forward_ios),
          ),
          // const Divider(),

          //About Us
          ListTile(
            title: Row(
              children: const [
                Icon(Icons.info),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'About Us',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutUs(),
                ),
              );
            },
            // trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}
