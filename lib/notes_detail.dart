import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:intl/intl.dart';
import 'notes_alkitab.dart';
import 'dart:math' as math;

class NotesDetail extends StatefulWidget {
  const NotesDetail({Key? key}) : super(key: key);

  @override
  State<NotesDetail> createState() => _NotesDetailState();
}

class _NotesDetailState extends State<NotesDetail> {
  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<ExpandableFabState>();
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        type: ExpandableFabType.up,
        key: _key,
        child: FloatingActionButton(
          onPressed: (() {
            final state = _key.currentState;
            if (state != null) {
              debugPrint('isOpen:${state.isOpen}');
              state.toggle();
            }
          }),
          child: const Icon(Icons.save),
        ),
        children: [
          FloatingActionButton.extended(
            onPressed: (() {}),
            icon: const Icon(Icons.close),
            label: Text("No"),
          ),
          FloatingActionButton.extended(
            onPressed: (() {}),
            icon: const Icon(Icons.check),
            label: Text("Yes"),
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text("Glory Living"),
        actions: [
          IconButton(
              onPressed: () {
                // WidgetsBinding.instance.addPostFrameCallback((_) {
                // Navigator.push(
                // context,
                // MaterialPageRoute(
                // builder: (context) => const NotesAlkitab()),
                // );
                // });
              },
              icon: Icon(Icons.book)),
        ],
        //TOBE REPLACED WITH  EXTERNAL NOTES APP
        // PRocess -> setstate per changes. auto updateing listener.
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 50,
          ),
        ),
      ),
    );
  }
}
