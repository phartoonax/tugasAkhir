import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'notes_alkitab.dart';

class NotesDetail extends StatefulWidget {
  const NotesDetail({Key? key}) : super(key: key);

  @override
  State<NotesDetail> createState() => _NotesDetailState();
}

class _NotesDetailState extends State<NotesDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Glory Living"),
        actions: [
          IconButton(
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotesAlkitab()),
                  );
                });
              },
              icon: Icon(Icons.book)),
        ],
        //TOBE REPLACED WITH  EXTERNAL NOTES APP
        // PRocess -> setstate per changes. auto updateing listener.
      ),
    );
  }
}
