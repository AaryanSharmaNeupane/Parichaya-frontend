import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/preferences.dart';
// import '../utils/is_first_run.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  static const routeName = '/onboard_screen';

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<Preferences>(context);
    final nextButton = Material(
      borderRadius: BorderRadius.circular(10),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        onPressed: () async {
          if (nameController.text.isNotEmpty) {
            prefs.setOnboardingAsComplete();
            prefs.setUsername(nameController.text);
            Navigator.of(context).pushReplacementNamed('/');
          } else {
            final snackBar = SnackBar(
                backgroundColor: Theme.of(context).errorColor,
                content: const Text('Please enter a name.'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: const Text(
          "Start using app",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
      ),
    );

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: null,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  Text(
                    'PARICHAYA',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    ),
                  ),
                  // Text(
                  //   'AN IDENTITY STORAGE AND SHARING APP',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.w400,
                  //   ),
                  // ),
                ],
              ),
              // SizedBox(height: 15),
              Column(
                children: [
                  // CustomTextField(
                  //   label: 'Enter your name:',
                  // ),
                  TextFormField(
                    autofocus: false,
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    onChanged: (username) {
                      username = nameController.text;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Enter your name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  nextButton,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
