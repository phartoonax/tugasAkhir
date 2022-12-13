import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'notes_detail.dart';

class NotesAlkitab extends StatefulWidget {
  const NotesAlkitab({Key? key}) : super(key: key);

  @override
  State<NotesAlkitab> createState() => NotesAlkitabState();
}

class NotesAlkitabState extends State<NotesAlkitab> {
  var num = [
    //TODO: REPLACE THIS WITH ACTUAL DATA FROM BES
    1,
    2,
    3,
    4,
    5,
    1,
    2,
    3,
    4,
    5,
    1,
    2,
    3,
    4,
    5,
    1,
    2,
    3,
    4,
    5,
  ];
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
                          itemCount: 12,
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext cont, int indx) {
                            return Container(
                                padding: EdgeInsets.only(top: 5),
                                child: RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: num[indx].toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall),
                                  TextSpan(
                                      text:
                                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum mattis, eros non malesuada condimentum, dui diam dapibus massa, et vehicula urna leo quis lorem. Duis eu justo condimentum, vestibulum ex sodales, laoreet purus. Integer eu bibendum risus, et lacinia ante. Maecenas cursus sem vel tellus scelerisque volutpat.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge)
                                ])));
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
