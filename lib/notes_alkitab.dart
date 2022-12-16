import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'notes_detail.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class NotesAlkitab extends StatefulWidget {
  const NotesAlkitab(
      {Key? key, required this.startindex, required this.endindex})
      : super(key: key);

  final int startindex;
  final int endindex;

  @override
  State<NotesAlkitab> createState() => NotesAlkitabState();
}

List _items = [];

class NotesAlkitabState extends State<NotesAlkitab> {
  Future<void> readJson() async {
    List tempitems = [];
    final String response = await rootBundle.loadString('assets/tbnew.json');
    final data = await json.decode(response);
    setState(() {
      tempitems = data;
      var temp = tempitems.where((bible) =>
          bible["id"] >= widget.startindex && bible["id"] <= widget.endindex);
      _items.addAll(temp);
      print(_items);
    });
  }

  initState() {
    super.initState();

    readJson();
  }

  pasalchecker(int indx) {
    if (pasalcounter != _items[indx]["pasal"]) {
      pasalcounter++;
      return Container(
          padding: EdgeInsets.only(top: 5),
          child: RichText(
              text: TextSpan(children: [
            TextSpan(
                text: _items[indx]["pasal"].toString() + "\n",
                style: Theme.of(context).textTheme.titleLarge),
            TextSpan(
                text: _items[indx]["pasal"].toString() +
                    ":" +
                    _items[indx]["ayat"].toString(),
                style: Theme.of(context).textTheme.labelSmall),
            TextSpan(
                text: _items[indx]["firman"],
                style: Theme.of(context).textTheme.labelLarge),
          ])));
    } else {
      return Container(
        padding: EdgeInsets.only(top: 5),
        child: RichText(
            text: TextSpan(children: [
          TextSpan(
              text: _items[indx]["pasal"].toString() +
                  ":" +
                  _items[indx]["ayat"].toString() +
                  " ",
              style: Theme.of(context).textTheme.labelSmall),
          TextSpan(
              text: _items[indx]["firman"],
              style: Theme.of(context).textTheme.labelLarge)
        ])),
      );
    }
  }

  int pasalcounter = 0;
//TODO: ADD ACTUAL PASSAGE FROM DB
  @override
  Widget build(BuildContext context) {
    final Future<String> _calculation = Future<String>.delayed(
      const Duration(seconds: 2),
      () => 'Data Loaded',
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text(
              "Glory Living"), // temp. REPLACE with actual scripture reading
          actions: [
            IconButton(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotesDetail()),
                    );
                  });
                },
                icon: Icon(Icons.notes_rounded)),
          ],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder<String>(
            future: _calculation,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 30),
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - 120,
                        child: ListView.builder(
                          itemCount: _items.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext cont, int indx) {
                            return pasalchecker(indx);
                          },
                        ),
                      ),
                    ),
                  )
                ];
              } else {
                children = <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  ),
                ];
              }
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ));
            },

            /// setup a listview for the scripture. style is tbd.
          ),
        ));
  }
}
