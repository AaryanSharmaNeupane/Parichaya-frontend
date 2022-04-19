import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parichaya_frontend/models/share_link_model.dart';
import 'package:parichaya_frontend/widgets/shared_document_details_tile.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../providers/share_links.dart';

import '../widgets/shared_document_details_tile.dart';
import '../utils/string.dart';
import '../widgets/options_modal_buttom_sheet.dart';
import '../widgets/delete_confirmation_buttom_sheet.dart';
import '../utils/date.dart';

// import '../widgets/custom_icons_icons.dart';

class ShareDetails extends StatefulWidget {
  const ShareDetails({Key? key}) : super(key: key);

  static const routeName = '/share_details';

  @override
  State<ShareDetails> createState() => _ShareDetailsState();
}

class _ShareDetailsState extends State<ShareDetails> {
  String formattedExpiryDuration = '';
  void showOptions(
    BuildContext context,
    ShareLink shareLink,
    String webUrl,
    int shareLinkId,
    String formattedExpiryDuration,
  ) {
    showOptionsModalButtomSheet(
      context,
      children: [
        const Text('Select Actions'),
        const Divider(),
        ListTile(
          leading:
              Icon(Icons.share_rounded, color: Theme.of(context).disabledColor),
          title: const Text('Share Document'),
          onTap: () {
            Navigator.of(context).pop();
            Share.share(webUrl, subject: shareLink.title);
          },
        ),
        ListTile(
          leading: Icon(Icons.link_off_outlined,
              color: Theme.of(context).errorColor),
          title: const Text('Expire this link'),
          onTap: () async {
            Navigator.of(context).pop();
            final Connectivity _connectivity = Connectivity();
            ConnectivityResult connectivityResult =
                await _connectivity.checkConnectivity();

            if (connectivityResult == ConnectivityResult.none) {
              Navigator.of(context).pop();
              final snackBar = SnackBar(
                  backgroundColor: Theme.of(context).errorColor,
                  content: const Text(
                      'You are currently offline. Please connect to your internet to expire this link.'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return;
            } else {
              final isConfirmed = await showDeleteConfirmationButtomSheet(
                  context,
                  message:
                      "You still have $formattedExpiryDuration left. Confirm delete?");
              if (isConfirmed) {
                Provider.of<ShareLinks>(context, listen: false)
                    .deleteShareLink(shareLinkId);
                Navigator.of(context).pop();

                const snackBar =
                    SnackBar(content: Text('Share Link Deleted Successfully'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final shareLinkId = ModalRoute.of(context)?.settings.arguments as int;
    final shareLink = Provider.of<ShareLinks>(context, listen: false)
        .getShareLinkById(shareLinkId);
    final webUrl =
        'http://165.232.180.17:8081/${shareLink.serverId}/${shareLink.encryptionKey}';

    formattedExpiryDuration = getFormattedExpiry(shareLink.expiryDate);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor),
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('DETAILS'),
        actions: [
          IconButton(
              onPressed: () {
                showOptions(context, shareLink, webUrl, shareLinkId,
                    formattedExpiryDuration);
              },
              icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            formattedExpiryDuration = getFormattedExpiry(shareLink.expiryDate);
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
                child: Text(
                  shareLink.title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                formattedExpiryDuration.isEmpty
                    ? 'Link Has Expired'
                    : 'Expires in $formattedExpiryDuration',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Material(
                  elevation: 2,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: QrImage(
                            data: webUrl,
                            size: 200,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(9),
                              width: 300,
                              height: 20,
                              child: Text(
                                generateLimitedLengthText(webUrl, 40),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Flexible(
                              child: IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: 20,
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: webUrl));
                                    const snackBar = SnackBar(
                                      content:
                                          Text('Link Copied to Clipboard.'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                  icon: const Icon(
                                    Icons.copy,
                                    color: Colors.black,
                                  )),
                            )
                          ],
                        ),
                        ElevatedButton(
                          // label: Text(text),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.share_rounded),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'SHARE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // icon: icon,
                          onPressed: () {
                            Share.share(webUrl, subject: shareLink.title);
                          },
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(0),

                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                // side: BorderSide(color: Colors.red),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColorDark),
                            foregroundColor: MaterialStateProperty.all(
                              Colors.white,
                              // overlayColor: MaterialStateProperty.all(
                              //     Theme.of(context).primaryColor.withOpacity(0.1)),
                            ),
                            // label: Text(text),
                            // child: Text(text),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
                child: const Text('SHARED DOCUMENTS'),
              ),
              const SizedBox(
                height: 10,
              ),
              SharedDocumentDetailsTiles(documents: shareLink.documents),
            ],
          ),
        ),
      ),
    );
  }
}
