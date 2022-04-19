import 'package:flutter/material.dart';
import 'package:parichaya_frontend/models/share_link_model.dart';
import 'package:provider/provider.dart';

import '../providers/share_links.dart';
import '../widgets/shared_document_tile.dart';
import 'share_details.dart';

class SharedList extends StatefulWidget {
  const SharedList({Key? key}) : super(key: key);

  @override
  State<SharedList> createState() => _SharedListState();
}

class _SharedListState extends State<SharedList> {
  late List<ShareLink> shareLinks;
  bool isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      shareLinks = Provider.of<ShareLinks>(context).items;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<ShareLinks>(context, listen: false).syncToDB();
        setState(() {
          shareLinks = Provider.of<ShareLinks>(context, listen: false).items;
        });
      },
      child: Provider.of<ShareLinks>(context).isSyncing
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.85 -
                    // appBar.preferredSize.height -
                    MediaQuery.of(context).padding.top,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
                        child: Text(
                          '${shareLinks.length} SHARABLE LINKS',
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    ...shareLinks.map((shareLink) {
                      return SharedDocumentTile(
                        title: shareLink.title.toUpperCase(),
                        expiryDate: shareLink.expiryDate,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              ShareDetails.routeName,
                              arguments: shareLink.id);
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
    );
  }
}
