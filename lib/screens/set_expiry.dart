import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parichaya_frontend/models/document_model.dart';
import 'package:parichaya_frontend/utils/date.dart';
import 'package:parichaya_frontend/widgets/ui/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'share_details.dart';

import '../providers/share_links.dart';
import '../widgets/ui/appbar_confirmation_button.dart';

class SetExpiry extends StatefulWidget {
  const SetExpiry({Key? key}) : super(key: key);

  static const routeName = '/set_expiry';

  @override
  State<SetExpiry> createState() => _SetExpiryState();
}

class _SetExpiryState extends State<SetExpiry> {
  final titleController = TextEditingController();
  final messageController = TextEditingController();
  DateTime expiryDate = DateTime.now().toLocal().add(const Duration(hours: 1));
  // final dateController = TextEditingController(
  //     text: DateTime.now().toLocal().add(const Duration(hours: 1)).toString());
  var _isloading = false;

  // void _showDatePicker() async {
  //   DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now().toLocal().add(const Duration(days: 1)),
  //     firstDate: DateTime.now().toLocal().add(const Duration(days: 1)),
  //     lastDate: DateTime.now().toLocal().add(
  //           const Duration(days: 7),
  //         ),
  //   );

  //   if (pickedDate != null) {
  //     String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
  //     setState(() {
  //       dateController.text = formattedDate;
  //     });
  //   }
  // }

  // void _showDateTimePicker() async {
  //   DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now().toLocal(),
  //     firstDate: DateTime.now().toLocal(),
  //     lastDate: DateTime.now().toLocal().add(
  //           const Duration(days: 7),
  //         ),
  //   );

  //   TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.fromDateTime(
  //       DateTime.now().toLocal().add(
  //             const Duration(hours: 1),
  //           ),
  //     ),
  //   );
  // DateTime? pickedDate = await showDatePicker(
  //   context: context,
  //   initialDate: DateTime.now().toLocal().add(const Duration(days: 1)),
  //   firstDate: DateTime.now().toLocal().add(const Duration(days: 1)),
  //   lastDate: DateTime.now().toLocal().add(
  //         const Duration(days: 7),
  //       ),
  // );

  //   if (pickedTime != null && pickedDate != null) {
  //     String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
  //     setState(() {
  //       dateController.text = formattedDate;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final selectedDocuments =
        ModalRoute.of(context)?.settings.arguments as List<Document>;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor),
        title: const Text('SET EXTRA INFO'),
        actions: [
          if (!_isloading)
            DoneButton(
              text: 'Done',
              icon: const Icon(Icons.done),
              onPressed: () async {
                if (titleController.text.isEmpty) {
                  final snackBar = SnackBar(
                      backgroundColor: Theme.of(context).errorColor,
                      content: const Text('Title is required.'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  // Provider.of<ShareLinks>(context, listen: false).syncToDB();
                  setState(() {
                    _isloading = true;
                  });
                  final Connectivity _connectivity = Connectivity();
                  ConnectivityResult connectivityResult =
                      await _connectivity.checkConnectivity();

                  if (connectivityResult == ConnectivityResult.none) {
                    final snackBar = SnackBar(
                        backgroundColor: Theme.of(context).errorColor,
                        content: const Text(
                            'You are currently offline. Please connect to your internet to create new share link.'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    setState(() {
                      _isloading = false;
                    });
                    return;
                  }
                  final newId =
                      await Provider.of<ShareLinks>(context, listen: false)
                          .addShareLink(
                    title: titleController.text,
                    expiryDate: expiryDate.toString(),
                    documents: selectedDocuments,
                  );
                  setState(() {
                    _isloading = false;
                  });
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                  if (newId == null) {
                    final snackBar = SnackBar(
                      backgroundColor: Theme.of(context).errorColor,
                      content: const Text(
                          'Some error has occured. Please try again in a while.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }

                  Navigator.of(context)
                      .pushNamed(ShareDetails.routeName, arguments: newId);
                }
              },
            )
        ],
      ),
      body: _isloading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Your Image Is Being Uploaded'),
                ],
              ),
            )
          : LayoutBuilder(
              builder: (ctx, constraints) {
                return SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          label: 'Title',
                          controller: titleController,
                          autofocus: true,
                          textInputAction: TextInputAction.next,
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: Text(
                            'Set Expiry',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),

                        SizedBox(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: CupertinoTheme(
                              data: CupertinoThemeData(
                                brightness: Theme.of(context).brightness,
                                textTheme: const CupertinoTextThemeData(
                                  dateTimePickerTextStyle: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              child: CupertinoDatePicker(
                                // mode: CupertinoDatePickerMode.date,
                                onDateTimeChanged: (newExpiryDateTime) {
                                  setState(() {
                                    expiryDate = newExpiryDateTime;
                                  });
                                },
                                initialDateTime: DateTime.now().toLocal().add(
                                      const Duration(
                                        hours: 1,
                                      ),
                                    ),
                                minimumDate: DateTime.now().toLocal().add(
                                      const Duration(
                                        minutes: 30,
                                      ),
                                    ),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              'Expires in ${getFormattedExpiry(expiryDate)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontSize: 15),
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // TextField(
                        //   controller: dateController,
                        //   decoration: InputDecoration(
                        //     icon: const Icon(Icons.watch_later_outlined),
                        //     filled: true,
                        //     fillColor: const Color.fromRGBO(220, 220, 220, 0.6),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //       borderSide: BorderSide.none,
                        //     ),
                        //   ),
                        //   readOnly: true,
                        //   onTap: _showTimePicker,
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
