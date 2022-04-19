import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parichaya_frontend/screens/no_internet.dart';
import 'package:parichaya_frontend/widgets/profile_drawer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import '../utils/string.dart';
import '../widgets/custom_icons_icons.dart';
import './add_document.dart';
import 'search_documents.dart';

// import './homepage.dart';
import './document_list.dart';
import './shared_list.dart';
import 'select_document.dart';

class ButtomNavigationBase extends StatefulWidget {
  const ButtomNavigationBase({Key? key}) : super(key: key);
  static const routeName = '/homepage';

  @override
  State<ButtomNavigationBase> createState() => _ButtomNavigationBaseState();
}

class _ButtomNavigationBaseState extends State<ButtomNavigationBase> {
  int _screenIndex = 0;
  bool isOnline = false;
  late StreamSubscription internetSubscription;

  void checkInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    bool connected = true;
    if (connectivityResult == ConnectivityResult.none) {
      connected = false;
    }
    setState(() {
      isOnline = connected;
    });
  }

  @override
  void initState() {
    super.initState();
    checkInternet();
    internetSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      bool connected = true;
      if (result == ConnectivityResult.none) {
        connected = false;
      }
      if (!connected && _screenIndex == 1) {
        const snackBar = SnackBar(
          content: Text('You are currently offline.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // Navigator.of(context).push(
        // MaterialPageRoute(builder: (context) => const NoInternetPage()));
      }
      setState(() {
        isOnline = connected;
      });
    });
  }

  @override
  void dispose() {
    internetSubscription.cancel();
    super.dispose();
  }

  void _selectScreen(int index) {
    setState(() {
      _screenIndex = index;
    });
  }

  final List<Map<String, Object>> _screens = [
    {
      'screen': const DocumentList(),
      'title': 'My Identity Docs',
    },
    {
      'screen': const SharedList(),
      // 'screen': const NoInternetPage(),
      'title': 'Shared Docs',
    },
  ];

  Widget? _getFAB() {
    if (_screenIndex == 0) {
      return FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AddDocuments.routeName);
          },
          tooltip: 'Add New Doc',
          elevation: 2,
          child: const Icon(
            Icons.add_rounded,
            size: 30,
          ));
    } else if (_screenIndex == 1 && isOnline) {
      return FloatingActionButton(
        onPressed: () {
          if (isOnline) {
            Navigator.of(context).pushNamed(SelectDocument.routeName);
          } else {
            const snackBar = SnackBar(content: Text('No Internet Connection.'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        tooltip: 'Add Shared Doc',
        elevation: 2,
        child: const Icon(
          Icons.add_link_rounded,
          size: 30,
        ),
      );
    }
    return null;
  }

  Widget _getBody() {
    if (!isOnline && _screenIndex == 1) {
      return const NoInternetPage();
    } else {
      return _screens[_screenIndex]['screen'] as Widget;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ProfileDrawer(),
      appBar: AppBar(
        elevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor),

        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  child: Icon(Icons.person_rounded),
                ),
              ),
            );
          },
        ),
        title: Text(
          generateLimitedLengthText(
              _screens[_screenIndex]['title'] as String, 25),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        // titleSpacing: 0.0,
        actions: [
          if (_screenIndex == 0)
            IconButton(
              splashRadius: 24,
              onPressed: () {
                Navigator.of(context).pushNamed(AddDocuments.routeName);
              },
              icon: const Icon(
                Icons.add_rounded,
                size: 30,
              ),
            ),
          if (_screenIndex == 1 && isOnline)
            IconButton(
              splashRadius: 24,
              onPressed: () {
                Navigator.of(context).pushNamed(SelectDocument.routeName);
              },
              icon: const Icon(
                Icons.add_link_rounded,
                size: 30,
              ),
            ),
          if (_screenIndex == 0)
            IconButton(
              splashRadius: 24,
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: DocumentSearchDelegate(),
                );
              },
              icon: const Icon(
                Icons.search,
                size: 30,
              ),
            ),
        ],
      ),
      // body: _screens[_screenIndex]['screen'] as Widget,
      body: _getBody(),
      floatingActionButton: _getFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        // type: BottomNavigationBarType.fixed,

        // unselectedFontSize: 14,
        selectedFontSize: 12,
        // showUnselectedLabels: true,
        elevation: 5,
        iconSize: 20,
        unselectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        // : Theme.of(context).unselectedWidgetColor.withOpacity(.2),
        selectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        currentIndex: _screenIndex,
        onTap: _selectScreen,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              CustomIcons.files_folder_filled,
            ),
            label: "My Docs",
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.link_filled),
            label: "Shared",
          ),
        ],
      ),
    );
  }
}
